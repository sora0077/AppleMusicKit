//
//  Response.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct Response<Resource: Decodable, Relationships: Decodable>: Decodable {
    public let resource: Resource
    public let relationships: Relationships
}
