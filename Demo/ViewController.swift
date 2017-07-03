//
//  ViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/06/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    convenience init(hex: String, alpha: CGFloat = 1) {
        var color: Int32 = 0
        Scanner(string: hex).scanInt32(&color)
        self.init(hex: Int(color), alpha: alpha)
    }
}

struct Storefront: AppleMusicKit.Storefront {
    typealias Identifier = String

    let name: String
    let defaultLanguageTag: String
}
struct Song: AppleMusicKit.Song {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes
    typealias PlayParameters = Demo.PlayParameters

    let name: String
    let artwork: Artwork
}
struct MusicVideo: AppleMusicKit.MusicVideo {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes
    typealias PlayParameters = Demo.PlayParameters

    let name: String
    let artwork: Artwork
}
struct Album: AppleMusicKit.Album {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes
    typealias PlayParameters = Demo.PlayParameters

    let name: String
}
struct Artist: AppleMusicKit.Artist {
    typealias Identifier = String
    typealias EditorialNotes = Demo.EditorialNotes

    let name: String
}
struct Genre: AppleMusicKit.Genre {
    typealias Identifier = String
    let name: String
}
struct Playlist: AppleMusicKit.Playlist {
    typealias Identifier = String
}
struct Curator: AppleMusicKit.Curator {
    typealias Identifier = String
}
struct Artwork: AppleMusicKit.Artwork {
    let bgColor: UIColor?

    private enum CodingKeys: String, CodingKey {
        case bgColor
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        bgColor = try c.decodeIfPresent(String.self, forKey: .bgColor).map { UIColor(hex: $0) }
    }
}
struct EditorialNotes: AppleMusicKit.EditorialNotes {
}
struct PlayParameters: AppleMusicKit.PlayParameters {
}

typealias GetSong = AppleMusicKit.GetSong<Song, Album, Artist, Genre>
typealias GetMusicVideo = AppleMusicKit.GetMusicVideo<MusicVideo, Album, Artist, Genre>
typealias GetAlbum = AppleMusicKit.GetAlbum<Album, Song, MusicVideo, Artist>
typealias GetArtist = AppleMusicKit.GetArtist<Artist, Album, Genre>
typealias GetPlaylist = AppleMusicKit.GetPlaylist<Playlist, Curator, Song, MusicVideo>
typealias GetCharts = AppleMusicKit.GetCharts<Song, MusicVideo, Album>
typealias SearchResources = AppleMusicKit.SearchResources<Song, MusicVideo, Album, Artist>
typealias GetStorefront = AppleMusicKit.GetStorefront<Storefront>
typealias GetMultipleStorefronts = AppleMusicKit.GetMultipleStorefronts<Storefront>
typealias GetAllStorefronts = AppleMusicKit.GetAllStorefronts<Storefront>
typealias GetUserStorefront = AppleMusicKit.GetUserStorefront<Storefront>

private func recursiveStorefronts(request: GetAllStorefronts?) {
    guard let request = request else {
        return
    }
    Session.shared.send(request) { result in
        switch result {
        case .success(let response):
            recursiveStorefronts(request: response.next)
        case .failure(let error):
            print(error)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recursiveStorefronts(request: GetAllStorefronts(limit: 5))
//        Session.shared.send(GetAllStorefronts(limit: 5)) { result in
//            switch result {
//            case .success(let response):
////                print(response)
//                if let next = response.next {
//                    Session.shared.send(next) { result in
//                        print(next)
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
