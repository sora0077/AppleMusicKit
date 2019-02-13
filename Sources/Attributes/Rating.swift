//
//  Rating.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2018/11/18.
//  Copyright © 2018 jp.sora0077. All rights reserved.
//

import Foundation

public protocol RatingDecodable: Attributes {
}

public protocol Rating: RatingDecodable, _AttributesCustomInitializable {

    init(id: Identifier,
         value: Int) throws
}

// MARK: - Rating
private enum CodingKeys: String, CodingKey {
    case value
}

extension Rating {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      value: c.decode(forKey: .value))
    }
}
