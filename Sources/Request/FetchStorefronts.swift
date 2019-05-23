//
//  FetchStorefronts.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

// MARK: - GetStorefront
public struct GetStorefront<Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public var path: String { return "/v1/storefronts/\(id)" }
    public let parameters: [String: Any]?

    private let id: Storefront.Identifier

    public init(id: Storefront.Identifier, language: Storefront.Language? = nil) {
        self.id = id
        self.parameters = ["l": language?.languageTag].cleaned
    }
}

// MARK: - GetMultipleStorefronts
public struct GetMultipleStorefronts<Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public var path: String { return "/v1/storefronts" }
    public let parameters: [String: Any]?

    public init(id: Storefront.Identifier, _ additions: Storefront.Identifier..., language: Storefront.Language? = nil) {
        self.init(ids: [id] + additions, language: language)
    }

    public init<C>(ids: C,
                   language: Storefront.Language? = nil) where C: Collection, C.Element == Storefront.Identifier {
        assert(!ids.isEmpty)
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag].cleaned
    }
}

// MARK: - GetAllStorefronts
public struct GetAllStorefronts<Storefront: StorefrontDecodable>: PaginatorResourceRequest, InternalPaginatorRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public let path: String
    public var parameters: [String: Any]? { return makePaginatorParameters(_parameters, request: self) }

    public internal(set) var limit: Int?
    public let offset: Int?
    private let _parameters: [String: Any]

    public init(language: Storefront.Language? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/storefronts",
                  parameters: ["l": language?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

// MARK: - GetUserStorefront
public struct GetUserStorefront<Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public var path: String { return "/v1/me/storefront" }
    public let parameters: [String: Any]?

    public init(language: Storefront.Language? = nil) {
        parameters = ["l": language?.languageTag].cleaned
    }
}
