//
//  FetchPlaylists.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/01.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetPlaylist<Playlist, Curator, Song, MusicVideo, Storefront>: ResourceRequest
    where
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Storefront: StorefrontDecodable {
    public typealias Resource = AppleMusicKit.Resource<Playlist, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/playlists/\(id)" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier
    private let id: Playlist.Identifier

    public init(storefront: Storefront.Identifier, id: Playlist.Identifier, language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetPlaylist {
    public struct Relationships: Decodable {
        public let curator: Page<GetCurator>
        public let tracks: Page<GetTracks>
    }
}

public struct GetMultiplePlaylists<Playlist, Curator, Song, MusicVideo, Storefront>: ResourceRequest
    where
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Storefront: StorefrontDecodable {
    public typealias Resource = AppleMusicKit.Resource<Playlist, GetPlaylist<Playlist, Curator, Song, MusicVideo, Storefront>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/playlists" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Playlist.Identifier, _ additions: Playlist.Identifier..., language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, language: language, include: include)
    }

    public init<C>(storefront: Storefront.Identifier,
                   ids: C,
                   language: Storefront.Language? = nil,
                   include: Set<ResourceType>? = nil) where C: Collection, C.Element == Playlist.Identifier {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetPlaylist {
    func curator(limit: Int? = nil, offset: Int? = nil) -> GetCurator {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }

    func tracks(limit: Int? = nil, offset: Int? = nil) -> GetTracks {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetPlaylist {
    public struct GetCurator: PaginatorResourceRequest, InternalPaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Curator, NoRelationships>
        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Playlist.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/playlists/\(id)/curator",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
    public struct GetTracks: PaginatorResourceRequest, InternalPaginatorRequest {
        public typealias Resource = Track<Song, MusicVideo, NoRelationships>
        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Playlist.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/playlists/\(id)/tracks",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
}
