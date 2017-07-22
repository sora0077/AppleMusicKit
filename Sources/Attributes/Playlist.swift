//
//  Playlist.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/01.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol PlaylistDecodable: Attributes {
}

public protocol Playlist: PlaylistDecodable {
    init(name: String) throws
}

public enum PlaylistType: String, Decodable {
    case userShared = "user-shared", editorial, external, personalMix = "personal-mix"
}

// MARK: - Playlist
private enum CodingKeys: String, CodingKey {
    case name
}

extension Playlist {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(name: c.decode(forKey: .name))
    }
}
