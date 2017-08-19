//
//  MusicVideo.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol MusicVideoDecodable: Attributes {
}

public protocol MusicVideo: MusicVideoDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes
    associatedtype PlayParameters: AppleMusicKit.PlayParameters

    init(id: Identifier,
         artistName: String,
         artwork: Artwork,
         contentRating: String?,
         durationInMillis: Int?,
         editorialNotes: EditorialNotes?,
         genreNames: [String],
         name: String,
         playParams: PlayParameters?,
         releaseDate: String,
         trackNumber: Int?,
         url: String,
         videoSubType: String?) throws
}

private enum CodingKeys: String, CodingKey {
    case artistName, artwork, contentRating, durationInMillis, editorialNotes, genreNames
    case name, playParams, releaseDate, trackNumber, url, videoSubType
}

extension MusicVideo {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      artistName: c.decode(forKey: .artistName),
                      artwork: c.decode(forKey: .artwork),
                      contentRating: c.decodeIfPresent(forKey: .contentRating),
                      durationInMillis: c.decodeIfPresent(forKey: .durationInMillis),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      genreNames: c.decode(forKey: .genreNames),
                      name: c.decode(forKey: .name),
                      playParams: c.decodeIfPresent(forKey: .playParams),
                      releaseDate: c.decode(forKey: .releaseDate),
                      trackNumber: c.decodeIfPresent(forKey: .trackNumber),
                      url: c.decode(forKey: .url),
                      videoSubType: c.decodeIfPresent(forKey: .videoSubType))
    }
}
