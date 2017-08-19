//
//  Album.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol AlbumDecodable: Attributes {
}

// MARK: - Album
public protocol Album: AlbumDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes
    associatedtype PlayParameters: AppleMusicKit.PlayParameters

    init(
        artistName: String,
        artwork: Artwork,
        contentRating: String?,
        copyright: String,
        editorialNotes: EditorialNotes?,
        genreNames: [String],
        isComplete: Bool,
        isSingle: Bool,
        name: String,
        releaseDate: String,
        playParams: PlayParameters?,
        trackCount: Int,
        url: String
    ) throws
}

private enum CodingKeys: String, CodingKey {
    case artistName, artwork, contentRating, copyright, editorialNotes, genreNames
    case isComplete, isSingle, name, releaseDate, playParams, trackCount, url
}

extension Album {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(artistName: c.decode(forKey: .artistName),
                      artwork: c.decode(forKey: .artwork),
                      contentRating: c.decodeIfPresent(forKey: .contentRating),
                      copyright: c.decode(forKey: .copyright),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      genreNames: c.decode(forKey: .genreNames),
                      isComplete: c.decode(forKey: .isComplete),
                      isSingle: c.decode(forKey: .isSingle),
                      name: c.decode(forKey: .name),
                      releaseDate: c.decode(forKey: .releaseDate),
                      playParams: c.decodeIfPresent(forKey: .playParams),
                      trackCount: c.decode(forKey: .trackCount),
                      url: c.decode(forKey: .url))
    }
}
