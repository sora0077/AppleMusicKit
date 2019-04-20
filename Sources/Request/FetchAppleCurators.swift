//
//  FetchAppleCurators.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/06.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetAppleCurator<
    Curator: AppleCuratorDecodable,
    Playlist: PlaylistDecodable,
    Storefront: StorefrontDecodable
>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Curator, Relationships>

    public var path: String { return "/v1/catalog/\(storefront)/apple-curators/\(id)" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier
    private let id: Curator.Identifier

    public init(storefront: Storefront.Identifier, id: Curator.Identifier, language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetAppleCurator {
    public struct Relationships: Decodable {
        public let playlists: Page<GetPlaylists>?
    }
}

extension GetAppleCurator {
    public func playlists(limit: Int? = nil, offset: Int? = nil) -> GetPlaylists {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetAppleCurator {
    public struct GetPlaylists: PaginatorResourceRequest, InternalPaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Playlist, NoRelationships>

        public let path: String
        public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

        public internal(set) var limit: Int?
        public let offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Curator.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/apple-curators/\(id)/playlists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
}

// MARK: - GetMultipleAppleCurators
public struct GetMultipleAppleCurators<
    Curator: AppleCuratorDecodable,
    Playlist: PlaylistDecodable,
    Storefront: StorefrontDecodable
>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Curator, GetAppleCurator<Curator, Playlist, Storefront>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/apple-curators" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Curator.Identifier, _ additions: Curator.Identifier..., language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, language: language, include: include)
    }

    public init<C>(storefront: Storefront.Identifier,
                   ids: C,
                   language: Storefront.Language? = nil,
                   include: Set<ResourceType>? = nil) where C: Collection, C.Element == Curator.Identifier {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}
