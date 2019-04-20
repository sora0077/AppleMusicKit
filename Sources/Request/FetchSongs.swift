//
//  FetchSongs.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetSong<Song, Album, Artist, Genre, Storefront>: ResourceRequest
where
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    Genre: GenreDecodable,
    Storefront: StorefrontDecodable {
    public typealias Resource = AppleMusicKit.Resource<Song, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/songs/\(id)" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier
    private let id: Song.Identifier

    public init(storefront: Storefront.Identifier, id: Song.Identifier, language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetSong {
    public struct Relationships: Decodable {
        public let albums: Page<GetAlbums>
        public let artists: Page<GetArtists>
        public let genres: Page<GetGenres>?
    }
}

public struct GetMultipleSongs<Song, Album, Artist, Genre, Storefront>: ResourceRequest
where
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    Genre: GenreDecodable,
    Storefront: StorefrontDecodable {
    public typealias Resource = AppleMusicKit.Resource<Song, GetSong<Song, Album, Artist, Genre, Storefront>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/songs" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Song.Identifier, _ additions: Song.Identifier..., language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, language: language, include: include)
    }

    public init<C>(storefront: Storefront.Identifier,
                   ids: C,
                   language: Storefront.Language? = nil,
                   include: Set<ResourceType>? = nil) where C: Collection, C.Element == Song.Identifier {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetSong {
    func albums(limit: Int? = nil, offset: Int? = nil) -> GetAlbums {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }

    func artists(limit: Int? = nil, offset: Int? = nil) -> GetArtists {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetSong {
    public struct GetAlbums: PaginatorResourceRequest, InternalPaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Album, NoRelationships>
        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/albums",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
    public struct GetArtists: PaginatorResourceRequest, InternalPaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Artist, NoRelationships>
        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
    public struct GetGenres: PaginatorResourceRequest, InternalPaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Genre, NoRelationships>
        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/genres",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
}
