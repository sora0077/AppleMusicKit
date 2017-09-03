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
    public let parameters: Any?

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

    public init(path: String, parameters: [String: Any]) {
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
            do {
                songs = try .init(from: decoder)
            } catch let error as DecodingError {
                switch error {
                case .keyNotFound(let key, _) where key.stringValue == "songs":
                    songs = nil
                default:
                    throw error
                }
            }
            do {
                musicVideos = try .init(from: decoder)
            } catch let error as DecodingError {
                switch error {
                case .keyNotFound(let key, _) where key.stringValue == "music-videos":
                    musicVideos = nil
                default:
                    throw error
                }
            }
            do {
                albums = try .init(from: decoder)
            } catch let error as DecodingError {
                switch error {
                case .keyNotFound(let key, _) where key.stringValue == "albums":
                    albums = nil
                default:
                    throw error
                }
            }
        }
    }
}

extension GetCharts {
    public struct Page<A: Attributes>: AppleMusicKit.Response {
        fileprivate struct Tmp: Decodable {
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
                if A.self == Song.self { return .songs }
                else if A.self == MusicVideo.self { return .musicVideos }
                else if A.self == Album.self { return .albums }
                else { fatalError() }
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
    public struct GetPage<A: Attributes>: PaginatorRequest {
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
        
        public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Page<A> {
            var page = try decode(object) as Page<A>
            page.next?.limit = limit
            return page
        }
    }
}
