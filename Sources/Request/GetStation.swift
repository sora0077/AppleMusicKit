//
//  GetStation.swift
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
    public let parameters: Any?

    private let storefront: Storefront.Identifier
    private let id: Station.Identifier

    public init(storefront: Storefront.Identifier, id: Station.Identifier, locale: Locale? = nil, include: Set<ResourceType>? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": makeInclude(include)].cleaned
    }
}

public struct GetMultipleStations<Station: StationDecodable, Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Station, NoRelationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/stations" }
    public let parameters: Any?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Station.Identifier, _ additions: Station.Identifier..., locale: Locale? = nil, include: Set<ResourceType>? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, locale: locale, include: include)
    }

    public init(storefront: Storefront.Identifier, ids: [Station.Identifier], locale: Locale? = nil, include: Set<ResourceType>? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": locale?.languageTag, "include": makeInclude(include)].cleaned
    }
}
