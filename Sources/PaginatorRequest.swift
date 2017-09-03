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
    var limit: Int? { get set }
    var offset: Int? { get set }
    init(path: String, parameters: [String: Any])
}

extension PaginatorRequest {
    public var method: HTTPMethod { return .get }

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        let str = try c.decode(String.self).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let comps = URLComponents(string: str)!
        let parameters = [String: Any](uniqueKeysWithValues: comps.queryItems?.map {
            ($0.name, $0.value ?? "") } ?? [])
        self.init(path: comps.path, parameters: parameters)
    }
}

extension PaginatorRequest where Response == Page<Self> {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Page<Self> {
        var page = try decode(object) as Page<Self>
        page.next?.limit = limit
        return page
    }
}


public protocol ResourcePaginatorRequest: PaginatorRequest {
    associatedtype Resource
}
