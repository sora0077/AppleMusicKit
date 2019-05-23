//
//  FetchCharts.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/02.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetCharts<Song, MusicVideo, Album, Genre, Storefront>: Request
where
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Album: AlbumDecodable,
    Genre: GenreDecodable,
    Storefront: StorefrontDecodable {
    public var method: HTTPMethod { return .get }
    public let path: String
    public let parameters: [String: Any]?

    public init(storefront: Storefront.Identifier, types: Set<ResourceType>,
                language: Storefront.Language? = nil,
                chart: String? = nil, genre: Genre.Identifier? = nil,
                limit: Int? = nil, offset: Int? = nil) {
        assert(types.contains(.songs) || types.contains(.musicVideos) || types.contains(.albums))
        self.init(path: "/v1/catalog/\(storefront)/charts",
            parameters: ["types": types.map { $0.rawValue }.joined(separator: ","),
                         "chart": chart, "genre": genre.map { "\($0)" },
                         "l": language?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        self.parameters = parameters
    }
}

extension GetCharts {
    public struct Response: AppleMusicKit.Response, Decodable {
        public let songs: Page<Song>?
        public let musicVideos: Page<MusicVideo>?
        public let albums: Page<Album>?

        public init(from decoder: Decoder) throws {
            func decode<D: Decodable>(forKey keyName: String) throws -> D? {
                do {
                    return try D.init(from: decoder)
                } catch let error as DecodingError {
                    switch error {
                    case .keyNotFound(let key, _) where key.stringValue == keyName:
                        return nil
                    default:
                        throw error
                    }
                }
            }
            songs = try decode(forKey: "songs")
            musicVideos = try decode(forKey: "music-videos")
            albums = try decode(forKey: "albums")
        }
    }
}

extension GetCharts {
    public struct Page<A: Attributes>: AppleMusicKit.Response {
        private struct Tmp: Decodable {
            let name: String
            let chart: String
            let data: [AppleMusicKit.Resource<A, NoRelationships>]
            let href: String?
            let next: GetCharts.GetPage<A>?
        }
        public let name: String
        public let chart: String
        public let data: [AppleMusicKit.Resource<A, NoRelationships>]
        public let href: String?
        public internal(set) var next: GetCharts.GetPage<A>?

        private enum RootKeys: String, CodingKey {
            case results
        }

        private enum CodingKeys: String, CodingKey {
            case songs, musicVideos = "music-videos", albums
        }

        public init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: RootKeys.self)
            let cc = try c.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
            let key: CodingKeys = {
                if A.self == Song.self {
                    return .songs
                } else if A.self == MusicVideo.self {
                    return .musicVideos
                } else if A.self == Album.self {
                    return .albums
                } else {
                    fatalError()
                }
            }()
            let tmp = try cc.decode([Tmp].self, forKey: key)[0]
            name = tmp.name
            chart = tmp.chart
            data = tmp.data
            href = tmp.href
            next = tmp.next
        }
    }
}

extension GetCharts {
    public struct GetPage<A: Attributes>: PaginatorRequest, InternalPaginatorRequest {
        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }

        public func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> Page<A> {
            var page = try decode(data, urlResponse: urlResponse) as Page<A>
            page.next?.limit = limit
            return page
        }
    }
}
