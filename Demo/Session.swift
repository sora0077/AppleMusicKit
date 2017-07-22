//
//  Session.swift
//  Demo
//
//  Created by 林達也 on 2017/07/22.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import APIKit
import Result
import AppleMusicKit

private struct AnyRequestWithData: AppleMusicKit.Request {
    typealias Response = (Any, Any)

    let method: HTTPMethod
    let baseURL: URL
    let path: String
    let dataParser: DataParser
    let headerFields: [String : String]
    let parameters: Any?
    let queryParameters: [String : Any]?
    let bodyParameters: BodyParameters?
    let scope: AccessScope

    private let interceptRequest: (URLRequest) throws -> URLRequest
    private let interceptObject: (Any, HTTPURLResponse) throws -> Any
    private let response: (Any, HTTPURLResponse) throws -> Response
    let raw: Any

    init<Req: AppleMusicKit.Request>(_ request: Req) {
        interceptRequest = request.intercept(urlRequest:)
        interceptObject = request.intercept(object:urlResponse:)
        response = { try (request.response(from: $0, urlResponse: $1), $0) }
        raw = request

        headerFields = request.headerFields
        method = request.method
        baseURL = request.baseURL
        path = request.path
        dataParser = request.dataParser
        parameters = request.parameters
        queryParameters = request.queryParameters
        bodyParameters = request.bodyParameters
        scope = request.scope
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        return try interceptRequest(urlRequest)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return try interceptObject(object, urlResponse)
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try response(object, urlResponse)
    }
}

class Session: AppleMusicKit.Session {
    override class var shared: Session { return _shared }
    private static let _shared
        = Session(adapter: URLSessionAdapter(configuration: URLSessionConfiguration.default))

    @discardableResult
    func send<Request>(
        with request: Request,
        callbackQueue: CallbackQueue? = nil,
        handler: @escaping (Result<(response: Request.Response, json: String), SessionTaskError>) -> Void)
        -> SessionTask? where Request : AppleMusicKit.Request {
            return super.send(AnyRequestWithData(request), callbackQueue: callbackQueue) { result in
                switch result {
                case .success(let response):
                    let json: String = {
                        do {
                            let object = try JSONSerialization.jsonObject(with: response.1 as? Data ?? Data(), options: [])
                            let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                            return String(data: data, encoding: .utf8) ?? ""
                        } catch {
                            return ""
                        }
                    }()
                    handler(Result(value: (response.0 as! Request.Response, json)))
                case .failure(let error):
                    handler(Result(error: error))
                }
            }
    }
}
