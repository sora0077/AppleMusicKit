//
//  SearchResources.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func decode<D: Decodable>(forKey key: K) throws -> D {
        return try decode(D.self, forKey: key)
    }
    func decodeIfPresent<D: Decodable>(forKey key: K) throws -> D? {
        return try decodeIfPresent(D.self, forKey: key)
    }
}

public struct SearchResources<Song, MusicVideo, Album, Artist>: Request
where
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable {
    public var method: HTTPMethod { return .get }
    public let path: String
    public let parameters: Any?

    public init(storefront: String, term: String,
                limit: Int? = nil, offset: Int? = nil,
                types: Set<ResourceType>? = nil) {
        self.init(path: "/v1/catalog/\(storefront)/search",
            parameters: ["term": term.replacingOccurrences(of: " ", with: "+"),
                         "types": types?.map { $0.rawValue }.joined(separator: ","),
                         "limit": limit, "offset": offset].cleaned)
    }

    public init(path: String, parameters: [String: Any]) {
        self.path = path
        self.parameters = parameters
    }
}

extension SearchResources {
    public struct Response: AppleMusicKit.Response, Decodable {
        public let songs: Page<GetPage<Song>>?
        public let musicVideos: Page<GetPage<MusicVideo>>?
        public let albums: Page<GetPage<Album>>?
        public let artists: Page<GetPage<Artist>>?

        private enum RootKeys: String, CodingKey {
            case results
        }
        private enum CodingKeys: String, CodingKey {
            case songs, musicVideos = "music-videos", albums, artists
        }

        public init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: RootKeys.self)
            let cc = try c.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
            songs = try cc.decodeIfPresent(forKey: .songs)
            musicVideos = try cc.decodeIfPresent(forKey: .musicVideos)
            albums = try cc.decodeIfPresent(forKey: .albums)
            artists = try cc.decodeIfPresent(forKey: .artists)
        }
    }
}

extension SearchResources {
    public struct GetPage<A: Attributes>: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<A, NoRelationships>
        public let path: String
        public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

        public var limit: Int?
        public var offset: Int?
        private let _parameters: [String: Any]

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
}
