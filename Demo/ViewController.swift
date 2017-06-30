//
//  ViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/06/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

struct Genre: AppleMusicKit.Genre {
    typealias Identifier = String
    let name: String
}

typealias GetAlbum = AppleMusicKit.GetAlbum<Album, Song, Artist>
typealias GetArtist = AppleMusicKit.GetArtist<Artist, Album, Genre>

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Session.shared.send(GetArtist(storefront: "us", id: "178834")) { result in
            switch result {
            case .success(let response):
                if let next = response.data.first?.relationships?.albums.next {
                    Session.shared.send(next) { result in
                        switch result {
                        case .success(let response):
                            print(response)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
