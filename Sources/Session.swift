//
//  Session.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import APIKit
import Result

private extension AccessScope {
    var requireUserToken: Bool {
        switch self {
        case .user: return true
        case .readonly: return false
        }
    }
}

public struct Authorization {
    public var developerToken: String
    public var musicUserToken: String?

    public init(developerToken: String, musicUserToken: String? = nil) {
        self.developerToken = developerToken
        self.musicUserToken = musicUserToken
    }
}

private struct AnyRequest<R>: APIKit.Request {
    typealias Response = R

    let method: HTTPMethod
    let baseURL: URL
    let path: String
    let dataParser: DataParser
    let headerFields: [String : String]
    let parameters: Any?
    let queryParameters: [String : Any]?
    let bodyParameters: BodyParameters?

    private let interceptRequest: (URLRequest) throws -> URLRequest
    private let interceptObject: (Any, HTTPURLResponse) throws -> Any
    private let response: (Any, HTTPURLResponse) throws -> R
    fileprivate let raw: Any

    init<Req: AppleMusicKit.Request>(_ request: Req, authorization: Authorization?) throws where Req.Response == R {
        interceptRequest = request.intercept(urlRequest:)
        interceptObject = request.intercept(object:urlResponse:)
        response = request.response
        raw = request

        var headers = request.headerFields
        if let developerToken = authorization?.developerToken {
            headers["Authorization"] = "Bearer \(developerToken)"
        } else {
            throw AppleMusicKitError.missingDeveloperToken
        }
        if let musicUserToken = authorization?.musicUserToken {
            headers["Music-User-Token"] = musicUserToken
        } else if request.scope.requireUserToken {
            throw AppleMusicKitError.missingMusicUserToken
        }
        headerFields = headers
        method = request.method
        baseURL = request.baseURL
        path = request.path
        dataParser = request.dataParser
        parameters = request.parameters
        queryParameters = request.queryParameters
        bodyParameters = request.bodyParameters
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        print(urlRequest)
        return try interceptRequest(urlRequest)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return try interceptObject(object, urlResponse)
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> R {
        return try response(object, urlResponse)
    }
}

open class Session: APIKit.Session {
    open override class var shared: Session {
        return _shared
    }
    private static let _shared
        = Session(adapter: URLSessionAdapter(configuration: URLSessionConfiguration.default))

    open var authorization: Authorization?

    @discardableResult
    open override class func send<Request>(
        _ request: Request,
        callbackQueue: CallbackQueue? = nil,
        handler: @escaping (Result<Request.Response, SessionTaskError>) -> Void)
        -> SessionTask? where Request : AppleMusicKit.Request {
            return shared.send(request, callbackQueue: callbackQueue, handler: handler)
    }

    @discardableResult
    open override func send<Request>(
        _ request: Request,
        callbackQueue: CallbackQueue? = nil,
        handler: @escaping (Result<Request.Response, SessionTaskError>) -> Void)
        -> SessionTask? where Request : AppleMusicKit.Request {
            do {
                return super.send(try AnyRequest(request, authorization: authorization),
                                  callbackQueue: callbackQueue,
                                  handler: handler)
            } catch {
                (callbackQueue ?? .main).execute {
                    handler(Result(error: SessionTaskError.requestError(error)))
                }
                return nil
            }
    }

    open override class func cancelRequests<Request>(
        with requestType: Request.Type,
        passingTest test: @escaping (Request) -> Bool)
        where Request : APIKit.Request {
            shared.cancelRequests(with: requestType, passingTest: test)
    }

    open override func cancelRequests<Request>(
        with requestType: Request.Type,
        passingTest test: @escaping (Request) -> Bool)
        where Request : APIKit.Request {
            super.cancelRequests(with: AnyRequest<Request.Response>.self) { request in
                (request.raw as? Request).map(test) ?? false
            }
    }
}
