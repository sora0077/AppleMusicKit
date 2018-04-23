//
//  Resource.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/01.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol Attributes: Decodable {
    associatedtype Identifier: Decodable & CustomStringConvertible
}

public protocol _AttributesCustomInitializable {}

public enum ResourceType: String, Decodable {
    case songs, albums, artists, musicVideos = "music-videos"
    case playlists
    case curators, appleCurators = "apple-curators", activities
    case stations, storefronts, genres
    case personalRecommendation = "personal-recommendation"
}

enum ResourceCodingKeys: String, CodingKey {
    case id, href, type, attributes, relationships
}

public struct Resource<A: Attributes, R: Decodable>: Decodable {
    public typealias Attributes = A
    public typealias Relationships = R
    public let id: Attributes.Identifier
    public let href: String
    public let type: ResourceType
    public let attributes: Attributes?
    public let relationships: Relationships?

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: ResourceCodingKeys.self)
        id = try c.decode(forKey: .id)
        href = try c.decode(forKey: .href)
        type = try c.decode(forKey: .type)
        relationships = try c.decodeIfPresent(forKey: .relationships)
        if Attributes.self is _AttributesCustomInitializable.Type {
            do {
                attributes = try Attributes(from: decoder)
            } catch DecodingError.keyNotFound(let key as ResourceCodingKeys, _) where key == .attributes {
                attributes = nil
            } catch DecodingError.valueNotFound(_, let context) where (context.codingPath.last as? ResourceCodingKeys) == .attributes {
                attributes = nil
            } catch {
                throw error
            }
        } else {
            attributes = try c.decodeIfPresent(forKey: .attributes)
        }
    }
}
