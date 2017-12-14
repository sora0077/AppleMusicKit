//
//  AnyRequest.swift
//  Demo
//
//  Created by 林達也 on 2017/07/19.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit
import APIKit

struct AnyRequest: AppleMusicKit.Request {
    typealias Response = Any

    let method: HTTPMethod
    let baseURL: URL
    let path: String
    let dataParser: DataParser
    let headerFields: [String: String]
    let parameters: Any?
    let queryParameters: [String: Any]?
    let bodyParameters: BodyParameters?
    let scope: AccessScope

    private let interceptRequest: (URLRequest) throws -> URLRequest
    private let interceptObject: (Any, HTTPURLResponse) throws -> Any
    private let response: (Any, HTTPURLResponse) throws -> Response
    let raw: Any

    init<Req: AppleMusicKit.Request>(_ request: Req) {
        interceptRequest = request.intercept(urlRequest:)
        interceptObject = request.intercept(object:urlResponse:)
        response = request.response
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
