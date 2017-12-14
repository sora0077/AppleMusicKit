//
//  Artwork.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol ArtworkDecodable: Decodable {
}

// MARK: - Artwork
public protocol Artwork: ArtworkDecodable {
    typealias Colors = (
        bgColor: String,
        textColor1: String,
        textColor2: String,
        textColor3: String,
        textColor4: String)

    init(
        width: Int,
        height: Int,
        url: String,
        colors: Colors?
    ) throws
}

private enum CodingKeys: CodingKey {
    case width, height, url, bgColor, textColor1, textColor2, textColor3, textColor4
}

extension Artwork {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        var colors: Colors?
        if let bgColor = try c.decodeIfPresent(String.self, forKey: .bgColor),
            let textColor1 = try c.decodeIfPresent(String.self, forKey: .textColor1),
            let textColor2 = try c.decodeIfPresent(String.self, forKey: .textColor2),
            let textColor3 = try c.decodeIfPresent(String.self, forKey: .textColor3),
            let textColor4 = try c.decodeIfPresent(String.self, forKey: .textColor4) {
            colors = (bgColor, textColor1, textColor2, textColor3, textColor4)
        }
        try self.init(width: c.decode(forKey: .width),
                      height: c.decode(forKey: .height),
                      url: c.decode(forKey: .url),
                      colors: colors)
    }
}
