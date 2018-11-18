//
//  Recommendation.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol RecommendationDecodable: Attributes {
}

// MARK: - Recommendation
public protocol Recommendation: RecommendationDecodable, _AttributesCustomInitializable {
    init(
        id: Identifier,
        isGroupRecommendation: Bool,
        nextUpdateDate: Date,
        reason: String?,
        resourceTypes: [ResourceType],
        title: String?
    ) throws
}

private enum CodingKeys: String, CodingKey {
    case isGroupRecommendation, title, reason, resourceTypes, nextUpdateDate
}

private struct Object: Decodable {
    let stringForDisplay: String
}

extension Recommendation {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      isGroupRecommendation: c.decode(forKey: .isGroupRecommendation),
                      nextUpdateDate: c.decode(forKey: .nextUpdateDate),
                      reason: c.decodeIfPresent(Object.self, forKey: .reason)?.stringForDisplay,
                      resourceTypes: c.decode(forKey: .resourceTypes),
                      title: c.decodeIfPresent(Object.self, forKey: .title)?.stringForDisplay)
    }
}
