//
//  Response.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol Attributes: Decodable {
    associatedtype Identifier: Decodable
}

public struct Resource<Attributes: AppleMusicKit.Attributes, Relationships: Decodable>: Decodable {
    public let id: Attributes.Identifier
    public let attributes: Attributes?
    public let relationships: Relationships?
}

struct ResponseRoot<Resource: Decodable>: Decodable {
    let data: [Resource]
}
