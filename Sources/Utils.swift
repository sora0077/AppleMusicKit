//
//  Utils.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

func makeIds<Identifier>(_ ids: [Identifier]) -> String {
    return ids.map(String.init(describing:)).joined(separator: ",")
}
