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
public protocol AppleCurator: CuratorDecodable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes

    init(artwork: Artwork, editorialNotes: EditorialNotes?, name: String, url: String) throws
}

private enum CodingKeys: String, CodingKey {
    case artwork, editorialNotes, name, url
}

extension AppleCurator {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(artwork: c.decode(forKey: .artwork),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      name: c.decode(forKey: .name),
                      url: c.decode(forKey: .url))
    }
}
