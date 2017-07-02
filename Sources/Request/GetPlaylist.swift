//
//  GetPlaylist.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/01.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetPlaylist<Playlist, Curator, Song, MusicVideo>: ResourceRequest
    where
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable {
    public typealias Resource = AppleMusicKit.Resource<Playlist, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/playlists/\(id)" }
    public let parameters: Any?
    
    private let storefront: String
    private let id: Playlist.Identifier
    
    public init(storefront: String, id: Playlist.Identifier, locale: Locale? = nil, include: [String]? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": include?.joined(separator: ",")].cleaned
    }
}

extension GetPlaylist {
    public struct Relationships: Decodable {
        public let curator: Page<GetCurator>
        public let tracks: Page<GetTracks>
    }
}

public struct GetMultiplePlaylists<Playlist, Curator, Song, MusicVideo>: ResourceRequest
    where
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable {
    public typealias Resource = AppleMusicKit.Resource<Playlist, GetPlaylist<Playlist, Curator, Song, MusicVideo>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/playlists" }
    public let parameters: Any?
    
    private let storefront: String
    
    public init(storefront: String, id: Playlist.Identifier, _ additions: Playlist.Identifier..., locale: Locale? = nil, include: [String]? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, locale: locale, include: include)
    }
    
    public init(storefront: String, ids: [Playlist.Identifier], locale: Locale? = nil, include: [String]? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": ids, "l": locale?.languageTag, "include": include].cleaned
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
    public struct GetCurator: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Curator, NoRelationships>
        public let path: String
        public let parameters: Any?
        
        init(storefront: String, id: Playlist.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/playlists/\(id)/curator",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }
        
        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
    public struct GetTracks: PaginatorRequest {
        public typealias Resource = Track<Song, MusicVideo, NoRelationships>
        public let path: String
        public let parameters: Any?
        
        init(storefront: String, id: Playlist.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/playlists/\(id)/tracks",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }
        
        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
}

