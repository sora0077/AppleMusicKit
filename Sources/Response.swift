//
//  Response.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol Attributes: Decodable {
    associatedtype Identifier: Decodable
}

public protocol Response: Decodable {
    associatedtype Resource
    var data: [Resource] { get }
}

public enum ResourceType: String, Decodable {
    case songs, albums, artists, musicVideos = "music-videos"
}

public struct Resource<A: Attributes, R: Decodable>: Decodable {
    public typealias Attributes = A
    public typealias Relationships = R
    public let id: Attributes.Identifier
    public let href: String
    public let type: ResourceType
    public let attributes: Attributes?
    public let relationships: Relationships?
}

public struct AnyResource: Decodable {
    private let decoder: Decoder
    public let id: String
    public let href: String
    public let type: ResourceType

    private enum CodingKeys: String, CodingKey {
        case id, href, type
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        href = try c.decode(String.self, forKey: .href)
        type = try c.decode(ResourceType.self, forKey: .type)
        self.decoder = decoder
    }

    public func resource<T, R>(with type: T.Type, _ relationships: R.Type) throws -> Resource<T, R> {
        return try Resource(from: decoder)
    }

    public func resource<T>(with type: T.Type) throws -> Resource<T, NoRelationships> {
        return try Resource(from: decoder)
    }
}

public struct ResponseRoot<Resource: Decodable>: Response {
    public let data: [Resource]
}

public struct Page<R: PaginatorRequest>: Response where R.Resource: Decodable {
    public let data: [R.Resource]
    public let href: String
    public let next: R?
}
