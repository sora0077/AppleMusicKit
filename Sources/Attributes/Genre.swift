//
//  Genre.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol GenreDecodable: Attributes {
}

// MARK: - Genre
public protocol Genre: GenreDecodable, _AttributesCustomInitializable {
    init(id: Identifier, name: String) throws
}

private enum CodingKeys: String, CodingKey {
    case name
}

extension Genre {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      name: c.decode(forKey: .name))
    }
}
