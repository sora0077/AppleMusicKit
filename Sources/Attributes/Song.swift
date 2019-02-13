//
//  Song.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol SongDecodable: Attributes {}

public protocol Song: SongDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes
    associatedtype PlayParameters: AppleMusicKit.PlayParameters
    associatedtype Preview: AppleMusicKit.Preview

    init(id: Identifier,
         albumName: String?,
         artistName: String,
         artwork: Artwork,
         composerName: String?,
         contentRating: String?,
         discNumber: Int,
         durationInMillis: Int?,
         editorialNotes: EditorialNotes?,
         genreNames: [String],
         isrc: String,
         movementCount: Int?,
         movementName: String?,
         movementNumber: Int?,
         name: String,
         playParams: PlayParameters?,
         previews: [Preview],
         releaseDate: Date,
         trackNumber: Int,
         url: URL,
         workName: String?) throws
}

private enum CodingKeys: String, CodingKey {
    case albumName, artistName, artwork, composerName, contentRating, discNumber, durationInMillis
    case editorialNotes, genreNames, isrc, movementCount, movementName, movementNumber, workName
    case name, playParams, previews, releaseDate, trackNumber, url
}

extension Song {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      albumName: c.decodeIfPresent(forKey: .albumName),
                      artistName: c.decode(forKey: .artistName),
                      artwork: c.decode(forKey: .artwork),
                      composerName: c.decodeIfPresent(forKey: .composerName),
                      contentRating: c.decodeIfPresent(forKey: .contentRating),
                      discNumber: c.decode(forKey: .discNumber),
                      durationInMillis: c.decodeIfPresent(forKey: .durationInMillis),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      genreNames: c.decode(forKey: .genreNames),
                      isrc: c.decode(forKey: .isrc),
                      movementCount: c.decodeIfPresent(forKey: .movementCount),
                      movementName: c.decodeIfPresent(forKey: .movementName),
                      movementNumber: c.decodeIfPresent(forKey: .movementNumber),
                      name: c.decode(forKey: .name),
                      playParams: c.decodeIfPresent(forKey: .playParams),
                      previews: c.decode(forKey: .previews),
                      releaseDate: c.decode(forKey: .releaseDate),
                      trackNumber: c.decode(forKey: .trackNumber),
                      url: c.decode(forKey: .url),
                      workName: c.decodeIfPresent(forKey: .workName))
    }
}
