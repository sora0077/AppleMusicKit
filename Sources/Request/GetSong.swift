//
//  GetSong.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any? {
    var cleaned: [String: Any] {
        return [String: Any](uniqueKeysWithValues: flatMap { (arg) in
            arg.value.map { (arg.key, $0) }
        })
    }
}

public struct GetSong<Song, Album, Artist>: Request
where
    Song: AppleMusicKit.Song,
    Album: AppleMusicKit.Album,
    Artist: AppleMusicKit.Artist {
    public typealias Response = Song
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/songs/\(id)" }

    private let storefront: String
    private let id: Song.Identifier

    public init(storefront: String, id: Song.Identifier) {
        self.storefront = storefront
        self.id = id
    }
}

extension GetSong {
    public struct GetAlbums: PaginatorRequest {
        public typealias Element = Album
        public let path: String
        public let parameters: Any?

        public init(storefront: String, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
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

        public init(storefront: String, id: Song.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/songs/\(id)/artists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            self.parameters = parameters
        }
    }
}
