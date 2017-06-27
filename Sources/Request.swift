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

extension Request where Response: Decodable {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try defaultDecoder.decode(Response.self, from: object as! Data)
    }
}
