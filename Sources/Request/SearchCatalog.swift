//
//  SearchCatalog.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct SearchResources<Song, MusicVideo, Album, Artist, Storefront>: Request
where
    Song: SongDecodable,
    MusicVideo: MusicVideoDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    Storefront: StorefrontDecodable {
    public var method: HTTPMethod { return .get }
    public let path: String
    public let parameters: [String: Any]?

    private let limit: Int?
    private let offset: Int?

    public init(storefront: Storefront.Identifier, term: String,
                language: Storefront.Language? = nil,
                limit: Int? = nil, offset: Int? = nil,
                types: Set<ResourceType>? = nil) {
        self.init(path: "/v1/catalog/\(storefront)/search",
            parameters: ["term": term.replacingOccurrences(of: " ", with: "+"),
                         "l": language?.languageTag,
                         "types": types?.map { $0.rawValue }.joined(separator: ","),
                         "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        self.parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }

    public func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> Response {
        var response: Response = try decode(data, urlResponse: urlResponse)
        response.songs?.next?.limit = limit
        response.musicVideos?.next?.limit = limit
        response.albums?.next?.limit = limit
        response.artists?.next?.limit = limit
        return response
    }
}

extension SearchResources {
    public struct Response: AppleMusicKit.Response, Decodable {
        public fileprivate(set) var songs: Page<Song>?
        public fileprivate(set) var musicVideos: Page<MusicVideo>?
        public fileprivate(set) var albums: Page<Album>?
        public fileprivate(set) var artists: Page<Artist>?

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
            artists = try decode(forKey: "artists")
        }
    }
}

extension SearchResources {
    public struct Page<A: Attributes>: AppleMusicKit.Response {
        public let data: [AppleMusicKit.Resource<A, NoRelationships>]
        public let href: String?
        public internal(set) var next: SearchResources.GetPage<A>?

        private enum RootKeys: String, CodingKey {
            case results
        }

        private enum ResourceKeys: String, CodingKey {
            case songs, musicVideos = "music-videos", albums, artists
        }

        private enum CodingKeys: String, CodingKey {
            case data, href, next
        }

        public init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: RootKeys.self)
            let cc = try c.nestedContainer(keyedBy: ResourceKeys.self, forKey: .results)
            let key: ResourceKeys = {
                if A.self == Song.self {
                    return .songs
                } else if A.self == MusicVideo.self {
                    return .musicVideos
                } else if A.self == Album.self {
                    return .albums
                } else if A.self == Artist.self {
                    return .artists
                } else {
                    fatalError()
                }
            }()
            let ccc = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: key)
            data = try ccc.decode(forKey: .data)
            href = try ccc.decodeIfPresent(forKey: .href)
            next = try ccc.decodeIfPresent(forKey: .next)
        }
    }
}

extension SearchResources {
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

// MARK: - GetSearchHints
public struct GetSearchHints<Storefront: StorefrontDecodable>: Request {
    public var method: HTTPMethod { return .get }
    public let path: String
    public let parameters: [String: Any]?

    public init(storefront: Storefront.Identifier, term: String,
                language: Storefront.Language? = nil,
                limit: Int? = nil, types: Set<ResourceType>? = nil) {
        self.path = "/v1/catalog/\(storefront)/search/hints"
        self.parameters = ["term": term.replacingOccurrences(of: " ", with: "+"),
                           "l": language?.languageTag,
                           "types": types?.map { $0.rawValue }.joined(separator: ","),
                           "limit": limit].cleaned
    }
}

extension GetSearchHints {
    public struct Response: AppleMusicKit.Response, Decodable {
        public let terms: [String]

        private enum RootKeys: String, CodingKey {
            case results
        }
        private enum CodingKeys: String, CodingKey {
            case terms
        }

        public init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: RootKeys.self)
            let cc = try c.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
            terms = try cc.decode(forKey: .terms)
        }
    }
}
