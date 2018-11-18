//
//  MusicVideo.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol MusicVideoDecodable: Attributes {}

public protocol MusicVideo: MusicVideoDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes
    associatedtype PlayParameters: AppleMusicKit.PlayParameters
    associatedtype Preview: AppleMusicKit.Preview

    init(id: Identifier,
         albumName: String?,
         artistName: String,
         artwork: Artwork,
         contentRating: String?,
         durationInMillis: Int?,
         editorialNotes: EditorialNotes?,
         genreNames: [String],
         isrc: String,
         name: String,
         playParams: PlayParameters?,
         previews: [Preview],
         releaseDate: Date,
         trackNumber: Int?,
         url: URL,
         videoSubType: String?,
         hasHDR: Bool,
         has4K: Bool) throws
}

private enum CodingKeys: String, CodingKey {
    case albumName, artistName, artwork, contentRating, durationInMillis, editorialNotes, genreNames
    case isrc, name, playParams, previews, releaseDate, trackNumber, url, videoSubType, hasHDR, has4K
}

extension MusicVideo {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      albumName: c.decodeIfPresent(forKey: .albumName),
                      artistName: c.decode(forKey: .artistName),
                      artwork: c.decode(forKey: .artwork),
                      contentRating: c.decodeIfPresent(forKey: .contentRating),
                      durationInMillis: c.decodeIfPresent(forKey: .durationInMillis),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      genreNames: c.decode(forKey: .genreNames),
                      isrc: c.decode(forKey: .isrc),
                      name: c.decode(forKey: .name),
                      playParams: c.decodeIfPresent(forKey: .playParams),
                      previews: c.decode(forKey: .previews),
                      releaseDate: c.decode(forKey: .releaseDate),
                      trackNumber: c.decodeIfPresent(forKey: .trackNumber),
                      url: c.decode(forKey: .url),
                      videoSubType: c.decodeIfPresent(forKey: .videoSubType),
                      hasHDR: c.decode(forKey: .hasHDR),
                      has4K: c.decode(forKey: .has4K))
    }
}
