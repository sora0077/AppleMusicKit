//
//  MusicVideo.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/30.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol MusicVideoDecodable: Attributes {
}

public protocol MusicVideo: MusicVideoDecodable {
    associatedtype Artwork: AppleMusicKit.Artwork
}
