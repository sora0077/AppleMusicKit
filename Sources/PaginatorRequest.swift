//
//  PaginatorRequest.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol PaginatorRequest: Request, Decodable {
    var limit: Int? { get }
    var offset: Int? { get }
}

extension PaginatorRequest {
    public var method: HTTPMethod { return .get }
}

private extension PaginatorRequest {
    mutating func set(limit: Int?) {
        var s = self as! InternalPaginatorRequest
        s.limit = limit
        self = s as! Self
    }
}

protocol InternalPaginatorRequest: Decodable {
    var limit: Int? { get set }
    init(path: String, parameters: [String: Any])
}

private struct InternalError: Error {}

extension InternalPaginatorRequest {
    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        let string = try c.decode(String.self)
        do {
            try self.init(_string: string)
        } catch {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "Invalid URL (\(string))")
        }
    }

    public init?(string: String) {
        try? self.init(_string: string)
    }

    private init(_string string: String) throws {
        let str = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let comps = URLComponents(string: str) else {
            throw InternalError()
        }
        let parameters = [String: Any?](uniqueKeysWithValues:
            comps.queryItems?.map { ($0.name, $0.value as Any?) } ?? []
        )
        self.init(path: comps.path, parameters: parameters.cleaned)
    }
}

extension PaginatorRequest where Response == Page<Self> {
    public func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> Page<Self> {
        var page = try decode(data, urlResponse: urlResponse) as Page<Self>
        page.next?.set(limit: limit)
        return page
    }
}

public protocol PaginatorResourceRequest: PaginatorRequest {
    associatedtype Resource
}

extension String {
    public init?<Req: PaginatorRequest>(_ req: Req) {
        guard let url = try? req.buildURL() else { return nil }
        self = url.absoluteString
    }
}
