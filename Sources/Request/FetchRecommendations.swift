//
//  FetchRecommendations.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

// MARK: - GetDefaultRecommendations
public struct GetDefaultRecommendations<
    Recommendation: RecommendationDecodable,
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    MusicVideo: MusicVideoDecodable,
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    AppleCurator: AppleCuratorDecodable,
    Activity: ActivityDecodable,
    Station: StationDecodable,
    Storefront: StorefrontDecodable,
    Genre: GenreDecodable
>: PaginatorResourceRequest, InternalPaginatorRequest {
    public typealias Resource = AppleMusicKit.Resource<Recommendation, Relationships>

    public var scope: AccessScope { return .user }
    public let path: String
    public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

    public internal(set) var limit: Int?
    public let offset: Int?
    private let _parameters: [String: Any]

    public init(type: ResourceType? = nil, language: Storefront.Language? = nil, limit: Int? = nil, offset: Int? = nil) {
        assert(type?.contains(in: .albums, .playlists) ?? true)
        self.init(path: "/v1/me/recommendations",
                  parameters: ["type": type?.rawValue, "l": language?.languageTag,
                               "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

extension GetDefaultRecommendations {
    public struct Relationships: Decodable {
        public let contents: [AnyResource<NoRelationships>]?
        public let recommendations: [Resource]?

        public typealias AnyResource<R: Decodable> = AppleMusicKit.AnyResource<
            Song,
            Album,
            Artist,
            MusicVideo,
            Playlist,
            Curator,
            AppleCurator,
            Activity,
            Station,
            Storefront,
            Genre,
            Recommendation,
            R>
    }
}

// MARK: - GetRecommendation
public struct GetRecommendation<
    Recommendation: RecommendationDecodable,
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    MusicVideo: MusicVideoDecodable,
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    AppleCurator: AppleCuratorDecodable,
    Activity: ActivityDecodable,
    Station: StationDecodable,
    Storefront: StorefrontDecodable,
    Genre: GenreDecodable
>: PaginatorResourceRequest, InternalPaginatorRequest {
    public typealias Relationships = GetDefaultRecommendations<Recommendation, Song, Album, Artist, MusicVideo, Playlist, Curator, AppleCurator, Activity, Station, Storefront, Genre>.Relationships
    public typealias Resource = AppleMusicKit.Resource<Recommendation, Relationships>

    public var scope: AccessScope { return .user }
    public let path: String
    public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

    public internal(set) var limit: Int?
    public let offset: Int?
    private let _parameters: [String: Any]

    public init(id: Recommendation.Identifier, language: Storefront.Language? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/me/recommendations/\(id)",
            parameters: ["l": language?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

// MARK: - GetMultipleRecommendations
public struct GetMultipleRecommendations<
    Recommendation: RecommendationDecodable,
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    MusicVideo: MusicVideoDecodable,
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    AppleCurator: AppleCuratorDecodable,
    Activity: ActivityDecodable,
    Station: StationDecodable,
    Storefront: StorefrontDecodable,
    Genre: GenreDecodable
>: PaginatorResourceRequest, InternalPaginatorRequest {
    public typealias Relationships = GetRecommendation<Recommendation, Song, Album, Artist, MusicVideo, Playlist, Curator, AppleCurator, Activity, Station, Storefront, Genre>.Relationships
    public typealias Resource = AppleMusicKit.Resource<Recommendation, Relationships>

    public var scope: AccessScope { return .user }
    public let path: String
    public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

    public internal(set) var limit: Int?
    public let offset: Int?
    private let _parameters: [String: Any]

    public init(id: Recommendation.Identifier, _ additions: Recommendation.Identifier...,
        language: Storefront.Language? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(ids: [id] + additions, language: language, limit: limit, offset: offset)
    }

    public init(ids: [Recommendation.Identifier], language: Storefront.Language? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/me/recommendations",
                  parameters: ["ids": makeIds(ids), "l": language?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}
