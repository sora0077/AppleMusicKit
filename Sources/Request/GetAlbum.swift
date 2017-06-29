//
//  GetAlbum.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/29.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetAlbum<Album, Song, Artist>: Request
    where
    Album: AppleMusicKit.Album,
    Song: AppleMusicKit.Song,
    Artist: AppleMusicKit.Artist {
    public typealias Resource = AppleMusicKit.Resource<Album, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/albums/\(id)" }
    public let parameters: Any?

    private let storefront: String
    private let id: Album.Identifier

    public init(storefront: String, id: Album.Identifier, locale: Locale? = nil, include: [String]? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": include?.joined(separator: ",")].cleaned
    }
}

extension GetAlbum {
    public struct Relationships: Decodable {
        public let tracks: Page<GetTracks>
        public let artists: Page<GetArtists>
    }
}

public struct GetMultipleAlbums<Album, Song, Artist>: Request
    where
    Album: AppleMusicKit.Album,
    Song: AppleMusicKit.Song,
    Artist: AppleMusicKit.Artist {
    public typealias Resource = AppleMusicKit.Resource<Album, GetAlbum<Album, Song, Artist>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/albums" }
    public let parameters: Any?

    private let storefront: String

    public init(storefront: String, id: Album.Identifier, _ additions: Album.Identifier..., locale: Locale? = nil, include: [String]? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, locale: locale, include: include)
    }

    public init(storefront: String, ids: [Album.Identifier], locale: Locale? = nil, include: [String]? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": ids, "l": locale?.languageTag, "include": include].cleaned
    }
}

extension GetAlbum {
    func tracks(limit: Int? = nil, offset: Int? = nil) -> GetTracks {
        return GetTracks(storefront: storefront, id: id, limit: limit, offset: offset)
    }

    func artists(limit: Int? = nil, offset: Int? = nil) -> GetArtists {
        return GetArtists(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetAlbum {
    public struct GetTracks: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Album, NoRelationships>
        public let path: String
        public let parameters: Any?

        init(storefront: String, id: Album.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/albums/\(id)/tracks",
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

        init(storefront: String, id: Album.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/albums/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
}
