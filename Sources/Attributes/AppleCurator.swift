//
//  AppleCurator.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol AppleCuratorDecodable: Attributes {
}

// MARK: - AppleCurator
public protocol AppleCurator: AppleCuratorDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes

    init(id: Identifier, artwork: Artwork, editorialNotes: EditorialNotes?, name: String, url: URL) throws
}

private enum CodingKeys: String, CodingKey {
    case artwork, editorialNotes, name, url
}

extension AppleCurator {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      artwork: c.decode(forKey: .artwork),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      name: c.decode(forKey: .name),
                      url: c.decode(forKey: .url))
    }
}
