//
//  Types.swift
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

extension String: Language {}

struct Storefront: AppleMusicKit.Storefront, CustomStringConvertible {
    typealias Identifier = String
    typealias Language = String

    let name: String
    let defaultLanguageTag: String

    var description: String {
        return name
    }

    init(id: Identifier, defaultLanguageTag: String, name: String, supportedLanguageTags: [String]) throws {
        self.name = name
        self.defaultLanguageTag = defaultLanguageTag
    }
}
struct Song: AppleMusicKit.Song, CustomStringConvertible {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes
    typealias PlayParameters = Demo.PlayParameters
    typealias Preview = Demo.Preview

    let name: String
    let artwork: Artwork

    var description: String {
        return name
    }

    init(id: Identifier, albumName: String, artistName: String, artwork: Artwork, composerName: String?, contentRating: String?, discNumber: Int, durationInMillis: Int?, editorialNotes: EditorialNotes?, genreNames: [String], isrc: String, movementCount: Int?, movementName: String?, movementNumber: Int?, name: String, playParams: PlayParameters?, previews: [Preview], releaseDate: String, trackNumber: Int, url: String, workName: String?) throws {
        self.name = name
        self.artwork = artwork
    }
}
struct MusicVideo: AppleMusicKit.MusicVideo, CustomStringConvertible {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes
    typealias PlayParameters = Demo.PlayParameters
    typealias Preview = Demo.Preview

    let name: String
    let artwork: Artwork

    var description: String {
        return name
    }

    init(id: Identifier, albumName: String?, artistName: String, artwork: Artwork, contentRating: String?, durationInMillis: Int?, editorialNotes: EditorialNotes?, genreNames: [String], isrc: String, name: String, playParams: PlayParameters?, previews: [Preview], releaseDate: String, trackNumber: Int?, url: String, videoSubType: String?) throws {
        self.name = name
        self.artwork = artwork
    }
}
struct Album: AppleMusicKit.Album, CustomStringConvertible {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes
    typealias PlayParameters = Demo.PlayParameters

    let name: String

    var description: String {
        return name
    }

    init(id: Identifier, albumName: String?, artistName: String, artwork: Artwork, contentRating: String?, copyright: String, editorialNotes: EditorialNotes?, genreNames: [String], isComplete: Bool, isSingle: Bool, name: String, recordLabel: String, releaseDate: String, playParams: PlayParameters?, trackCount: Int, url: String) throws {
        self.name = name
        print(artwork)
    }
}
struct Artist: AppleMusicKit.Artist, CustomStringConvertible {
    typealias Identifier = String
    typealias EditorialNotes = Demo.EditorialNotes

    let name: String

    var description: String {
        return name
    }

    init(id: Identifier, genreNames: [String], editorialNotes: EditorialNotes?, name: String, url: String) throws {
        self.name = name
    }
}
struct Genre: AppleMusicKit.Genre, CustomStringConvertible {
    typealias Identifier = String
    let name: String

    var description: String {
        return name
    }

    init(id: Identifier, name: String) throws {
        self.name = name
    }
}
struct Playlist: AppleMusicKit.Playlist, CustomStringConvertible {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes
    typealias PlayParameters = Demo.PlayParameters

    let name: String

    var description: String {
        return name
    }

    init(id: Identifier, artwork: Artwork?, curatorName: String?, description: EditorialNotes?, lastModifiedDate: String, name: String, playlistType: PlaylistType, playParams: PlayParameters?, url: String) throws {
        self.name = name
    }
}
struct Curator: AppleMusicKit.Curator, CustomStringConvertible {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes

    let name: String

    var description: String {
        return name
    }

    init(id: Identifier, artwork: Artwork, editorialNotes: EditorialNotes?, name: String, url: String) throws {
        self.name = name
        print(artwork, editorialNotes)
    }
}
struct AppleCurator: AppleMusicKit.AppleCurator, CustomStringConvertible {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes

    let name: String

    var description: String {
        return name
    }

    init(id: Identifier, artwork: Artwork, editorialNotes: EditorialNotes?, name: String, url: String) throws {
        self.name = name
        print(artwork, editorialNotes)
    }
}
struct Activity: AppleMusicKit.Activity {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes

    init(id: Identifier, artwork: Artwork, editorialNotes: EditorialNotes?, name: String, url: String) throws {
        print(artwork, editorialNotes)
    }
}
struct Station: AppleMusicKit.Station, CustomStringConvertible {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork
    typealias EditorialNotes = Demo.EditorialNotes

    let name: String
    let isLive: Bool

    var description: String {
        return name
    }

    init(id: Identifier, artwork: Artwork, durationInMillis: Int?, editorialNotes: EditorialNotes?, episodeNumber: Int?, isLive: Bool, name: String, url: String) throws {
        self.name = name
        self.isLive = isLive
    }
}
struct Artwork: AppleMusicKit.Artwork {
    init(width: Int, height: Int, url: String, colors: Colors?) throws {
        print(colors)
    }
}
struct EditorialNotes: AppleMusicKit.EditorialNotes {
    init(standard: String?, short: String?) throws {
    }
}
struct PlayParameters: AppleMusicKit.PlayParameters {
    init(id: String, kind: String) throws {
    }
}
struct Preview: AppleMusicKit.Preview {
    typealias Artwork = Demo.Artwork

    init(url: String, artwork: Artwork?) throws {
    }
}

typealias GetSong = AppleMusicKit.GetSong<Song, Album, Artist, Genre, Storefront>
typealias GetMusicVideo = AppleMusicKit.GetMusicVideo<MusicVideo, Album, Artist, Genre, Storefront>
typealias GetAlbum = AppleMusicKit.GetAlbum<Album, Song, MusicVideo, Artist, Storefront>
typealias GetArtist = AppleMusicKit.GetArtist<Artist, Album, Genre, Storefront>
typealias GetMultipleArtists = AppleMusicKit.GetMultipleArtists<Artist, Album, Genre, Storefront>
typealias GetPlaylist = AppleMusicKit.GetPlaylist<Playlist, Curator, Song, MusicVideo, Storefront>
typealias GetStation = AppleMusicKit.GetStation<Station, Storefront>
typealias GetCharts = AppleMusicKit.GetCharts<Song, MusicVideo, Album, Genre, Storefront>
typealias GetCurator = AppleMusicKit.GetCurator<Curator, Playlist, Storefront>
typealias GetMultipleCurators = AppleMusicKit.GetMultipleCurators<Curator, Playlist, Storefront>
typealias GetAppleCurator = AppleMusicKit.GetAppleCurator<AppleCurator, Playlist, Storefront>
typealias GetMultipleAppleCurators = AppleMusicKit.GetMultipleAppleCurators<AppleCurator, Playlist, Storefront>
typealias GetActivity = AppleMusicKit.GetActivity<Activity, Playlist, Storefront>
typealias GetMultipleActivities = AppleMusicKit.GetMultipleActivities<Activity, Playlist, Storefront>
typealias SearchResources = AppleMusicKit.SearchResources<Song, MusicVideo, Album, Artist, Storefront>
typealias GetStorefront = AppleMusicKit.GetStorefront<Storefront>
typealias GetMultipleStorefronts = AppleMusicKit.GetMultipleStorefronts<Storefront>
typealias GetAllStorefronts = AppleMusicKit.GetAllStorefronts<Storefront>
typealias GetUserStorefront = AppleMusicKit.GetUserStorefront<Storefront>
typealias GetMultipleStations = AppleMusicKit.GetMultipleStations<Station, Storefront>
typealias GetTopChartGenres = AppleMusicKit.GetTopChartGenres<Genre, Storefront>
typealias GetGenre = AppleMusicKit.GetGenre<Genre, Storefront>
typealias GetMultipleGenres = AppleMusicKit.GetMultipleGenres<Genre, Storefront>
typealias GetSearchHints = AppleMusicKit.GetSearchHints<Storefront>
