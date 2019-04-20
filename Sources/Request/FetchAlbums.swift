//
//  FetchAlbums.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/29.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetAlbum<Album, Song, MusicVideo, Artist, Storefront>: ResourceRequest
    where
    Album: AlbumDecodable,
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Artist: ArtistDecodable,
    Storefront: StorefrontDecodable {
    public typealias Resource = AppleMusicKit.Resource<Album, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/albums/\(id)" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier
    private let id: Album.Identifier

    public init(storefront: Storefront.Identifier, id: Album.Identifier, language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetAlbum {
    public struct Relationships: Decodable {
        public let tracks: Page<GetTracks>
        public let artists: Page<GetArtists>
    }
}

public struct GetMultipleAlbums<Album, Song, MusicVideo, Artist, Storefront>: ResourceRequest
    where
    Album: AlbumDecodable,
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Artist: ArtistDecodable,
    Storefront: StorefrontDecodable {
    public typealias Resource = AppleMusicKit.Resource<Album, GetAlbum<Album, Song, MusicVideo, Artist, Storefront>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/albums" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Album.Identifier, _ additions: Album.Identifier..., language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, language: language, include: include)
    }

    public init<C>(storefront: Storefront.Identifier,
                   ids: C,
                   language: Storefront.Language? = nil,
                   include: Set<ResourceType>? = nil) where C: Collection, C.Element == Album.Identifier {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetAlbum {
    func tracks(limit: Int? = nil, offset: Int? = nil) -> GetTracks {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }

    func artists(limit: Int? = nil, offset: Int? = nil) -> GetArtists {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetAlbum {
    public struct GetTracks: PaginatorResourceRequest, InternalPaginatorRequest {
        public typealias Resource = Track<Song, MusicVideo, NoRelationships>
        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Album.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/albums/\(id)/tracks",
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

        init(storefront: Storefront.Identifier, id: Album.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/albums/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
}
