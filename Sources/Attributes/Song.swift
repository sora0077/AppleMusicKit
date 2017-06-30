//
//  Song.swift
//  AppleMusicKit
//
//  Created by 林達也 on 2017/06/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol SongDecodable: Attributes {
}

public protocol Song: SongDecodable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes
    associatedtype PlayParameters: AppleMusicKit.PlayParameters
}
