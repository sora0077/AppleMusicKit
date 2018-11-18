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

public protocol Playlist: PlaylistDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes
    associatedtype PlayParameters: AppleMusicKit.PlayParameters

    init(id: Identifier,
         artwork: Artwork?,
         curatorName: String?,
         description: EditorialNotes?,
         lastModifiedDate: Date,
         name: String,
         playlistType: PlaylistType,
         playParams: PlayParameters?,
         url: URL) throws
}

public enum PlaylistType: String, Decodable {
    case userShared = "user-shared", editorial, external, personalMix = "personal-mix"
}

// MARK: - Playlist
private enum CodingKeys: String, CodingKey {
    case artwork, curatorName, description, lastModifiedDate, name, playlistType, playParams, url
}

extension Playlist {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      artwork: c.decodeIfPresent(forKey: .artwork),
                      curatorName: c.decodeIfPresent(forKey: .curatorName),
                      description: c.decodeIfPresent(forKey: .description),
                      lastModifiedDate: c.decode(forKey: .lastModifiedDate),
                      name: c.decode(forKey: .name),
                      playlistType: c.decode(forKey: .playlistType),
                      playParams: c.decodeIfPresent(forKey: .playParams),
                      url: c.decode(forKey: .url))
    }
}
