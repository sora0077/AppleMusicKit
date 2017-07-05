//
//  GetCharts.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/02.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetCharts<Song, MusicVideo, Album, Storefront>: Request
where
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Album: AlbumDecodable,
    Storefront: StorefrontDecodable {
    public var method: HTTPMethod { return .get }
    public let path: String
    public let parameters: Any?

    public init(storefront: Storefront.Identifier, types: Set<ResourceType>,
                language: Storefront.Language? = nil,
                chart: String? = nil, genre: String? = nil,
                limit: Int? = nil, offset: Int? = nil) {
        assert(types.contains(.songs) || types.contains(.musicVideos) || types.contains(.albums))
        self.init(path: "/v1/catalog/\(storefront)/charts",
            parameters: ["types": types.map { $0.rawValue }.joined(separator: ","),
                         "l": language?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    public init(path: String, parameters: [String: Any]) {
        self.path = path
        self.parameters = parameters
    }
}

extension GetCharts {
    public struct Response: AppleMusicKit.Response, Decodable {
        public let songs: Page<GetPage<Song>>?
        public let musicVideos: Page<GetPage<MusicVideo>>?
        public let albums: Page<GetPage<Album>>?

        private enum RootKeys: String, CodingKey {
            case results
        }
        private enum CodingKeys: String, CodingKey {
            case songs, musicVideos = "music-videos", albums
        }

        public init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: RootKeys.self)
            let cc = try c.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
            songs = try cc.decodeIfPresent([Page<GetPage<Song>>].self, forKey: .songs)?.first
            musicVideos = try cc.decodeIfPresent([Page<GetPage<MusicVideo>>].self, forKey: .musicVideos)?.first
            albums = try cc.decodeIfPresent([Page<GetPage<Album>>].self, forKey: .albums)?.first
        }
    }
}

extension GetCharts {
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
