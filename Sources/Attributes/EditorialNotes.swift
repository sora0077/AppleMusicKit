//
//  EditorialNotes.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol EditorialNotesDecodable: Decodable {
}

// MARK: - EditorialNotes
public protocol EditorialNotes: EditorialNotesDecodable {
    init(standard: String, short: String) throws
}

private enum CodingKeys: String, CodingKey {
    case standard, short
}

extension EditorialNotes {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(standard: c.decodeIfPresent(forKey: .standard) ?? "",
                      short: c.decodeIfPresent(forKey: .short) ?? "")
    }
}
