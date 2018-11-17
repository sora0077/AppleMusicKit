//
//  FetchStations.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetStation<Station: StationDecodable, Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Station, NoRelationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/stations/\(id)" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier
    private let id: Station.Identifier

    public init(storefront: Storefront.Identifier, id: Station.Identifier, language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

public struct GetMultipleStations<Station: StationDecodable, Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Station, NoRelationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/stations" }
    public let parameters: [String: Any]?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Station.Identifier, _ additions: Station.Identifier..., language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, language: language, include: include)
    }

    public init<C>(storefront: Storefront.Identifier,
                   ids: C,
                   language: Storefront.Language? = nil,
                   include: Set<ResourceType>? = nil) where C: Collection, C.Element == Station.Identifier {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}
