//
//  GetArtist.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetArtist<Artist, Album, Genre>: ResourceRequest
    where
    Artist: ArtistDecodable,
    Album: AlbumDecodable,
    Genre: GenreDecodable {
    public typealias Resource = AppleMusicKit.Resource<Artist, Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/artists/\(id)" }
    public let parameters: Any?

    private let storefront: String
    private let id: Artist.Identifier

    public init(storefront: String, id: Artist.Identifier, locale: Locale? = nil, include: [String]? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": include?.joined(separator: ",")].cleaned
    }
}

extension GetArtist {
    public struct Relationships: Decodable {
        public let albums: Page<GetAlbums>
        public let genres: Page<GetGenres>?
    }
}

public struct GetMultipleArtists<Artist, Album, Genre>: ResourceRequest
    where
    Artist: ArtistDecodable,
    Album: AlbumDecodable,
    Genre: GenreDecodable {
    public typealias Resource = AppleMusicKit.Resource<Artist, GetArtist<Artist, Album, Genre>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/albums" }
    public let parameters: Any?

    private let storefront: String

    public init(storefront: String, id: Artist.Identifier, _ additions: Artist.Identifier..., locale: Locale? = nil, include: [String]? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, locale: locale, include: include)
    }

    public init(storefront: String, ids: [Artist.Identifier], locale: Locale? = nil, include: [String]? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": locale?.languageTag, "include": include].cleaned
    }
}

extension GetArtist {
    func albums(limit: Int? = nil, offset: Int? = nil) -> GetAlbums {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }

    func genres(limit: Int? = nil, offset: Int? = nil) -> GetGenres {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetArtist {
    public struct GetAlbums: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Album, NoRelationships>
        public let path: String
        public let parameters: Any?

        init(storefront: String, id: Artist.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/artists/\(id)/albums",
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

        init(storefront: String, id: Artist.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/artists/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
}
