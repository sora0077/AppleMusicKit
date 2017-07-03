//
//  GetStorefront.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetStorefront<Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public var path: String { return "/v1/storefronts/\(id)" }
    public let parameters: Any?

    private let id: Storefront.Identifier

    public init(id: Storefront.Identifier, local: Locale? = nil) {
        self.id = id
        self.parameters = ["l": local?.languageTag].cleaned
    }
}

public struct GetMultipleStorefronts<Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public var path: String { return "/v1/storefronts" }
    public let parameters: Any?

    public init(id: Storefront.Identifier, _ additions: Storefront.Identifier..., local: Locale? = nil) {
        self.init(ids: [id] + additions, local: local)
    }

    public init(ids: [Storefront.Identifier], local: Locale? = nil) {
        assert(!ids.isEmpty)
        self.parameters = ["ids": makeIds(ids), "l": local?.languageTag].cleaned
    }
}

public struct GetAllStorefronts<Storefront: StorefrontDecodable>: PaginatorRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public let path: String
    public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

    public var limit: Int?
    public var offset: Int?
    private let _parameters: [String: Any]

    public init(local: Locale? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/storefronts",
                  parameters: ["l": local?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    public init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

public struct GetUserStorefront<Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Storefront, NoRelationships>

    public var path: String { return "/v1/me/storefront" }
    public let parameters: Any?

    public init(local: Locale? = nil) {
        parameters = ["l": local?.languageTag].cleaned
    }
}
