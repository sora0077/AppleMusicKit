//
//  Error.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/07/06.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public enum AppleMusicKitError: Error {
    case missingDeveloperToken
    case missingMusicUserToken
    case invalidURL(URL, Error?)
    case responseError(Errors?, Data, HTTPURLResponse?)
    case internalError(Error, Data, HTTPURLResponse?)
}

extension AppleMusicKitError {
    public struct Errors: Swift.Error, Decodable, RandomAccessCollection {
        public struct Error: Swift.Error, Decodable {
            public let id: String
            public let code: Int
            public let status: Int
            public let title: String
            public let detail: String?

            private enum CodingKeys: String, CodingKey {
                case id, code, status, title, detail
            }

            public init(from decoder: Decoder) throws {
                let c = try decoder.container(keyedBy: CodingKeys.self)
                id = try c.decode(forKey: .id)
                code = Int(try c.decode(String.self, forKey: .code))!
                status = Int(try c.decode(String.self, forKey: .status))!
                title = try c.decode(forKey: .title)
                detail = try c.decodeIfPresent(forKey: .detail)
            }
        }
        private let errors: [Error]

        public var startIndex: Int { return errors.startIndex }
        public var endIndex: Int { return errors.endIndex }

        public subscript(position: Int) -> Error {
            return errors[position]
        }

        public func index(after i: Int) -> Int {
            return errors.index(after: i)
        }
    }
}
