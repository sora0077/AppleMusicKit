//
//  AppleMusicKit.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import APIKit

let defaultDecoder = JSONDecoder()

public struct NoRelationships: Decodable {}

extension Dictionary where Key == String, Value == Any? {
    var cleaned: [String: Any] {
        return [String: Any](uniqueKeysWithValues: flatMap { (arg) in
            arg.value.map { (arg.key, $0) }
        })
    }
}
