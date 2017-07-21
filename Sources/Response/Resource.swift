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
    case curators, appleCurators = "apple-curators", activities
    case stations, storefronts, genres
    case personalRecommendation = "personal-recommendation"
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
