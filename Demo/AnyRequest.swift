//
//  AnyRequest.swift
//  Demo
//
//  Created by 林達也 on 2017/07/19.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit

struct AnyRequest<R>: AppleMusicKit.Request {
    typealias Response = (R, Data)

    let method: HTTPMethod
    let baseURL: URL
    let path: String
    let headerFields: [String: String]
    let parameters: [String: Any]?
    let scope: AccessScope

    private let response: (Data, HTTPURLResponse?) throws -> Response
    let raw: Any

    init<Req: AppleMusicKit.Request>(_ request: Req) where R == Req.Response {
        response = { data, response in
            try (request.response(from: data, urlResponse: response), data)
        }
        raw = request

        headerFields = request.headerFields
        parameters = request.parameters
        method = request.method
        baseURL = request.baseURL
        path = request.path
        scope = request.scope
    }

    func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> Response {
        return try response(data, urlResponse)
    }
}
