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
public protocol Genre: GenreDecodable {
    init(name: String) throws
}

private enum CodingKeys: String, CodingKey {
    case name
}

extension Genre {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(name: c.decode(forKey: .name))
    }
}
