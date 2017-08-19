//
//  Storefront.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol Language {
    var languageTag: String { get }
}

public extension Language where Self: StringProtocol {
    var languageTag: String { return String(self) }
}

public protocol StorefrontDecodable: Attributes {
    associatedtype Language: AppleMusicKit.Language
}

// MARK: - Storefront
public protocol Storefront: StorefrontDecodable, _AttributesCustomInitializable {
    init(id: Identifier, defaultLanguageTag: Language, name: String, supportedLanguageTags: [Language]) throws
}

private enum CodingKeys: String, CodingKey {
    case defaultLanguageTag, name, supportedLanguageTags
}

extension Storefront where Language: Decodable {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(id: cc.decode(forKey: .id),
                      defaultLanguageTag: c.decode(forKey: .defaultLanguageTag),
                      name: c.decode(forKey: .name),
                      supportedLanguageTags: c.decode(forKey: .supportedLanguageTags))
    }
}
