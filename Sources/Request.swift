//
//  Request.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get
}

public enum AccessScope {
    case readonly, user
}

public protocol Request {
    associatedtype Response

    var scope: AccessScope { get }
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }

    var headerFields: [String: String] { get }
    var parameters: [String: Any]? { get }

    func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> Response
}

public protocol ResourceRequest: Request {
    associatedtype Resource
}

extension ResourceRequest {
    public var method: HTTPMethod { return .get }
}

extension Request {
    public var scope: AccessScope { return .readonly }

    public var baseURL: URL { return URL(string: "https://api.music.apple.com")! }

    public var headerFields: [String: String] { return [:] }

    public func intercept(data: Data, urlResponse: HTTPURLResponse?) throws -> Data {
        if let urlResponse = urlResponse,
            let contentType = urlResponse.allHeaderFields["Content-Type"] as? String,
            contentType.hasPrefix("text/plain") {
            throw AppleMusicKitError.unexpectedResponse(data, urlResponse)
        }
        return data
    }
}

extension Request where Response: Decodable {
    public func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> Response {
        return try decode(data)
    }
}

extension ResourceRequest where Resource: Decodable {
    public func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> ResponseRoot<Resource> {
        return try decode(data)
    }
}
