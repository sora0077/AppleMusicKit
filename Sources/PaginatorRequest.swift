//
//  PaginatorRequest.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import APIKit

public protocol PaginatorRequest: Request, Decodable {
    associatedtype Element: Decodable
    typealias Response = Page<Self>

    init(path: String, parameters: [String: Any])
    func elements(from data: Data, urlResponse: HTTPURLResponse) throws -> [Element]
}

public struct Page<R: PaginatorRequest>: Decodable {
    public let data: [R.Element]
    public let next: R?
}

private enum PaginatorRequestCodingKeys: String, CodingKey {
    case next
}

extension PaginatorRequest {
    public var method: HTTPMethod { return .get }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: PaginatorRequestCodingKeys.self)
        let comps = URLComponents(string: try c.decode(String.self, forKey: .next))!
        let parameters = [String: Any](uniqueKeysWithValues: comps.queryItems?.map {
            ($0.name, $0.value ?? "") } ?? [])
        self.init(path: comps.path, parameters: parameters)
    }

    public func elements(from data: Data, urlResponse: HTTPURLResponse) throws -> [Element] {
        return try defaultDecoder.decode([Element].self, from: data)
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Page<Self> {
        return try defaultDecoder.decode(Page<Self>.self, from: object as! Data)
    }
}
