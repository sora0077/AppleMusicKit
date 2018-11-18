//
//  Station.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol StationDecodable: Attributes {
}

// MARK: - Station
public protocol Station: StationDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes

    init(id: Identifier,
         artwork: Artwork,
         durationInMillis: Int?,
         editorialNotes: EditorialNotes?,
         episodeNumber: Int?,
         isLive: Bool,
         name: String,
         url: URL) throws
}

private enum CodingKeys: String, CodingKey {
    case artwork, durationInMillis, editorialNotes, episodeNumber, isLive, name, url
}

extension Station {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      artwork: c.decode(forKey: .artwork),
                      durationInMillis: c.decodeIfPresent(forKey: .durationInMillis),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      episodeNumber: c.decodeIfPresent(forKey: .episodeNumber),
                      isLive: c.decode(forKey: .isLive),
                      name: c.decode(forKey: .name),
                      url: c.decode(forKey: .url))
    }
}
