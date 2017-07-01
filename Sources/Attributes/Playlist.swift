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
}

public enum PlaylistType: String, Decodable {
    case userShared = "user-shared", editorial, external, personalMix = "personal-mix"
}
