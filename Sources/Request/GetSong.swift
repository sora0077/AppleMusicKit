//
//  GetSong.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

protocol Include {
    associatedtype Relationships
}

public struct GetSong<Song, Album, Artist>: Request
where
    Song: AppleMusicKit.Song,
    Album: AppleMusicKit.Album,
    Artist: AppleMusicKit.Artist {
    public typealias Response = AppleMusicKit.Response<Song, Relationships?>?
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/songs/\(id)" }
    public let parameters: Any?

    private let storefront: String
    private let id: Song.Identifier

    public init(storefront: String, id: Song.Identifier, locale: Locale? = nil, include: [String]? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": include].cleaned
    }
}

extension GetSong {
    public struct Relationships: Decodable {
        public let albums: Page<GetAlbums>
        public let artists: Page<GetArtists>
    }
}

public struct GetMultipleSongs<Song, Album, Artist>: Request
where
    Song: AppleMusicKit.Song,
    Album: AppleMusicKit.Album,
    Artist: AppleMusicKit.Artist {
    public typealias Response = [GetSong<Song, Album, Artist>.Response]
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
        self.parameters = ["ids": ids, "l": locale?.languageTag, "include": include].cleaned
    }
}

extension GetSong {
    func albums(limit: Int? = nil, offset: Int? = nil) -> GetAlbums {
        return GetAlbums(storefront: storefront, id: id, limit: limit, offset: offset)
    }

    func artists(limit: Int? = nil, offset: Int? = nil) -> GetArtists {
        return GetArtists(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetSong {
    public struct GetAlbums: PaginatorRequest {
        public typealias Element = AppleMusicKit.Response<Album, NoRelationships>
        public let path: String
        public let parameters: Any?

        init(storefront: String, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/albums",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
    public struct GetArtists: PaginatorRequest {
        public typealias Element = Artist
        public let path: String
        public let parameters: Any?

        init(storefront: String, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
}
