//
//  AppleMusicKit.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import APIKit

public struct NoRelationships: Decodable {}

private let defaultDecoder = JSONDecoder()

func decode<D: Decodable>(_ data: Data) throws -> D {
    do {
        return try defaultDecoder.decode(D.self, from: data)
    } catch let modelError {
        do {
            throw try defaultDecoder.decode(Errors.self, from: data)
        } catch let error as Errors {
            throw error
        } catch {
            throw modelError
        }
    }
}
