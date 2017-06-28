//
//  Request.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import APIKit

public typealias HTTPMethod = APIKit.HTTPMethod
public protocol Request: APIKit.Request {
    associatedtype Resource

    func response(from resources: [Resource]) throws -> Response
}

private struct FoundationDataParser: DataParser {
    var contentType: String? { return nil }

    func parse(data: Data) throws -> Any { return data }
}

extension Request {
    public var baseURL: URL { return URL(string: "https://api.music.apple.com")! }

    public var dataParser: DataParser {
        return FoundationDataParser()
    }
}

extension Request where Resource: Decodable {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let root = try defaultDecoder.decode(ResponseRoot<Resource>.self, from: object as! Data)
        return try response(from: root.data)
    }
}

extension Request where Response == [Resource] {
    public func response(from resources: [Resource]) throws -> Response {
        return resources
    }
}

extension Request where Response == Resource? {
    public func response(from resources: [Resource]) throws -> Response {
        return resources.first
    }
}
