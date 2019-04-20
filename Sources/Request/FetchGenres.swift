//
//  FetchGenres.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetTopChartGenres<Genre: GenreDecodable, Storefront: StorefrontDecodable>: PaginatorResourceRequest, InternalPaginatorRequest {
    public typealias Resource = AppleMusicKit.Resource<Genre, NoRelationships>

    public let path: String
    public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

    public internal(set) var limit: Int?
    public let offset: Int?
    private let _parameters: [String: Any]

    public init(storefront: Storefront.Identifier, language: Storefront.Language? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/catalog/\(storefront)/genres",
            parameters: ["l": language?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

public struct GetGenre<Genre: GenreDecodable, Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Genre, NoRelationships>

    public var path: String { return "/v1/catalog/\(storefront)/genres/\(id)" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier
    private let id: Genre.Identifier

    public init(storefront: Storefront.Identifier, id: Genre.Identifier, language: Storefront.Language? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": language?.languageTag].cleaned
    }
}

public struct GetMultipleGenres<Genre: GenreDecodable, Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Genre, NoRelationships>

    public var path: String { return "/v1/catalog/\(storefront)/genres" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Genre.Identifier, _ additions: Genre.Identifier..., language: Storefront.Language? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, language: language)
    }

    public init<C>(storefront: Storefront.Identifier,
                   ids: C,
                   language: Storefront.Language? = nil) where C: Collection, C.Element == Genre.Identifier {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag].cleaned
    }
}
