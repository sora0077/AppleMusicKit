//
//  GetSong.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetSong<Song, Album, Artist, Genre>: ResourceRequest
where
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    Genre: GenreDecodable {
    public typealias Resource = AppleMusicKit.Resource<Song, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/songs/\(id)" }
    public let parameters: Any?

    private let storefront: String
    private let id: Song.Identifier

    public init(storefront: String, id: Song.Identifier, locale: Locale? = nil, include: [String]? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": include?.joined(separator: ",")].cleaned
    }
}

extension GetSong {
    public struct Relationships: Decodable {
        public let albums: Page<GetAlbums>
        public let artists: Page<GetArtists>
        public let genres: Page<GetGenres>?
    }
}

public struct GetMultipleSongs<Song, Album, Artist, Genre>: ResourceRequest
where
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    Genre: GenreDecodable {
    public typealias Resource = AppleMusicKit.Resource<Song, GetSong<Song, Album, Artist, Genre>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/songs" }
    public let parameters: Any?

    private let storefront: String

    public init(storefront: String, id: Song.Identifier, _ additions: Song.Identifier..., locale: Locale? = nil, include: [String]? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, locale: locale, include: include)
    }

    public init(storefront: String, ids: [Song.Identifier], locale: Locale? = nil, include: [String]? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": locale?.languageTag, "include": include].cleaned
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
    public struct GetAlbums: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Album, NoRelationships>
        public let path: String
        public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

        public var limit: Int?
        public var offset: Int?
        private let _parameters: [String: Any]

        init(storefront: String, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/albums",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
    public struct GetArtists: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Artist, NoRelationships>
        public let path: String
        public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

        public var limit: Int?
        public var offset: Int?
        private let _parameters: [String: Any]

        init(storefront: String, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
    public struct GetGenres: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Genre, NoRelationships>
        public let path: String
        public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

        public var limit: Int?
        public var offset: Int?
        private let _parameters: [String: Any]

        init(storefront: String, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/genres",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
}
