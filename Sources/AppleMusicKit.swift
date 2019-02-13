//
//  AppleMusicKit.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct NoRelationships: Decodable {}

private let defaultDecoder: JSONDecoder = {
    let decoder = JSONDecoder()

    let  iso8601Full = ISO8601DateFormatter()
    iso8601Full.formatOptions = .withInternetDateTime
    let iso8601Date = ISO8601DateFormatter()
    iso8601Date.formatOptions = [.withFullDate, .withDashSeparatorInDate]
    decoder.dateDecodingStrategy = .custom { decoder in
        let c = try decoder.singleValueContainer()
        let str = try c.decode(String.self)
        let date: Date? = {
            if str.count == 10 {
                return iso8601Date.date(from: str)
            } else {
                return iso8601Full.date(from: str)
            }
        }()
        return try date ?? {
            let description = "Expected to decode \(type(of: Date.self)) but found invalid format \"\(str)\""
            throw DecodingError.typeMismatch(Date.self, .init(codingPath: decoder.codingPath,
                                                              debugDescription: description))
        }()
    }
    return decoder
}()

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
