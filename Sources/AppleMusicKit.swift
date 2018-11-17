//
//  AppleMusicKit.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct NoRelationships: Decodable {}

private let defaultDecoder = JSONDecoder()

func decode<D: Decodable>(_ data: Data, urlResponse: HTTPURLResponse?) throws -> D {
    switch urlResponse?.statusCode {
    case (200..<300)?:
        do {
            return try defaultDecoder.decode(D.self, from: data)
        } catch {
            throw AppleMusicKitError.internalError(error, data, urlResponse)
        }
    case (400...)? where !data.isEmpty:
        do {
            throw try defaultDecoder.decode(AppleMusicKitError.Errors.self, from: data)
        } catch let error as AppleMusicKitError.Errors {
            throw AppleMusicKitError.responseError(error, data, urlResponse)
        } catch {
            throw AppleMusicKitError.internalError(error, data, urlResponse)
        }
    case _:
        throw AppleMusicKitError.responseError(nil, data, urlResponse)
    }
}
