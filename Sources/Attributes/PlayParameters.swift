//
//  PlayParameters.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol PlayParametersDecodable: Decodable {
}

// MARK: - PlayParameters
public protocol PlayParameters: PlayParametersDecodable {
    init(id: String, kind: String) throws
}

private enum CodingKeys: String, CodingKey {
    case id, kind
}

extension PlayParameters {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(id: c.decode(forKey: .id), kind: c.decode(forKey: .kind))
    }
}
