//
//  FetchHistory.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetHeavyRotationContent<
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
    Genre: GenreDecodable,
    Recommendation: RecommendationDecodable
>: PaginatorResourceRequest, InternalPaginatorRequest {
    public typealias Resource = AnyResource<NoRelationships>

    public var scope: AccessScope { return .user }
    public let path: String
    public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

    public internal(set) var limit: Int?
    public let offset: Int?
    private let _parameters: [String: Any]

    public init(language: Storefront.Language? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/me/history/heavy-rotation",
            parameters: ["l": language?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

extension GetHeavyRotationContent {
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
