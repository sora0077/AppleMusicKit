//
//  ViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/06/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Session.shared.send(GetAlbum<Album, Song, Artist>(storefront: "us", id: "310730204", include: ["songs"])) { result in
            switch result {
            case .success(let response):
                do {
                    let track = response.data.first?.relationships?.tracks.data.first
                    print(try track?.resource(with: Song.self).attributes?.name ?? "")
                } catch {
                    print(error)
                }
                if let next = response.data.first?.relationships?.tracks.next {
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
