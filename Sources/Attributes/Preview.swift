//
//  Preview.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2018/05/26.
//  Copyright © 2018年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol PreviewDecodable: Decodable {}

// MARK: - Preview
public protocol Preview: PreviewDecodable {
    associatedtype Artwork: AppleMusicKit.Artwork

    init(
        artwork: Artwork?,
        url: URL
    ) throws
}

private enum CodingKeys: CodingKey {
    case url, artwork
}

extension Preview {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(artwork: c.decodeIfPresent(forKey: .artwork),
                      url: c.decode(forKey: .url))
    }
}
