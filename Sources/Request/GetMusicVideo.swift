//
//  GetMusicVideo.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetMusicVideo<MusicVideo, Album, Artist, Genre>: ResourceRequest
    where
    MusicVideo: MusicVideoDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    Genre: GenreDecodable {
    public typealias Resource = AppleMusicKit.Resource<MusicVideo, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/music-videos/\(id)" }
    public let parameters: Any?

    private let storefront: String
    private let id: MusicVideo.Identifier

    public init(storefront: String, id: MusicVideo.Identifier, locale: Locale? = nil, include: [String]? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": include?.joined(separator: ",")].cleaned
    }
}

extension GetMusicVideo {
    public struct Relationships: Decodable {
        public let albums: Page<GetAlbums>
        public let artists: Page<GetArtists>
        public let genres: Page<GetGenres>?
    }
}

public struct GetMultipleMusicVideos<MusicVideo, Album, Artist, Genre>: ResourceRequest
    where
    MusicVideo: MusicVideoDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    Genre: GenreDecodable {
    public typealias Resource = AppleMusicKit.Resource<MusicVideo, GetMusicVideo<MusicVideo, Album, Artist, Genre>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/music-videos" }
    public let parameters: Any?

    private let storefront: String

    public init(storefront: String, id: MusicVideo.Identifier, _ additions: MusicVideo.Identifier..., locale: Locale? = nil, include: [String]? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, locale: locale, include: include)
    }

    public init(storefront: String, ids: [MusicVideo.Identifier], locale: Locale? = nil, include: [String]? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": locale?.languageTag, "include": include].cleaned
    }
}

extension GetMusicVideo {
    func albums(limit: Int? = nil, offset: Int? = nil) -> GetAlbums {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }

    func artists(limit: Int? = nil, offset: Int? = nil) -> GetArtists {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetMusicVideo {
    public struct GetAlbums: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Album, NoRelationships>
        public let path: String
        public let parameters: Any?

        init(storefront: String, id: MusicVideo.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/music-videos/\(id)/albums",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
    public struct GetArtists: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Artist, NoRelationships>
        public let path: String
        public let parameters: Any?

        init(storefront: String, id: MusicVideo.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/music-videos/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
    public struct GetGenres: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Genre, NoRelationships>
        public let path: String
        public let parameters: Any?

        init(storefront: String, id: MusicVideo.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/genres",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
}
