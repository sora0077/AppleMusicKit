//
//  Artist.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol ArtistDecodable: Attributes {
}

// MARK: - Artist
public protocol Artist: ArtistDecodable, _AttributesCustomInitializable {
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes

    init(genreNames: [String],
         editorialNotes: EditorialNotes?,
         name: String,
         url: String) throws
}

private enum CodingKeys: String, CodingKey {
    case genreNames, editorialNotes, name, url
}

extension Artist {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(genreNames: c.decode(forKey: .genreNames),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      name: c.decode(forKey: .name),
                      url: c.decode(forKey: .url))
    }
}
