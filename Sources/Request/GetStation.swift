//
//  GetStation.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetStation<Station: StationDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Station, NoRelationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/stations/\(id)" }
    public let parameters: Any?

    private let storefront: String
    private let id: Station.Identifier

    public init(storefront: String, id: Station.Identifier, locale: Locale? = nil, include: [String]? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": locale?.languageTag, "include": include?.joined(separator: ",")].cleaned
    }
}

public struct GetMultipleStations<Station: StationDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Station, NoRelationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/stations" }
    public let parameters: Any?

    private let storefront: String

    public init(storefront: String, id: Station.Identifier, _ additions: Station.Identifier..., locale: Locale? = nil, include: [String]? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, locale: locale, include: include)
    }

    public init(storefront: String, ids: [Station.Identifier], locale: Locale? = nil, include: [String]? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": locale?.languageTag, "include": include].cleaned
    }
}
