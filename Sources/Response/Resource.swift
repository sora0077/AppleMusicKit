//
//  Resource.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/01.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol Attributes: Decodable {
    associatedtype Identifier: Decodable
}

public enum ResourceType: String, Decodable {
    case songs, albums, artists, musicVideos = "music-videos"
    case playlists
    case appleCurators = "apple-curators"
    case stations, storefronts, genres
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
        return try .init(from: decoder)
    }

    public func resource<T>(with type: T.Type) throws -> Resource<T, NoRelationships> {
        return try .init(from: decoder)
    }
}

public enum Track<Song: SongDecodable, MusicVideo: MusicVideoDecodable, R: Decodable>: Decodable {
    case song(Resource<Song, R>), musicVideo(Resource<MusicVideo, R>)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let type = try c.decode(ResourceType.self, forKey: .type)
        switch type {
        case .songs:
            self = .song(try .init(from: decoder))
        case .musicVideos:
            self = .musicVideo(try .init(from: decoder))
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: c.codingPath, debugDescription: "\(#function)@\(#line)"))
        }
    }
}
