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

public protocol Storefront: StorefrontDecodable {
}
