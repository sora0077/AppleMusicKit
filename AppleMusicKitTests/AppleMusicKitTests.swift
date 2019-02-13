//
//  AppleMusicKitTests.swift
//  AppleMusicKitTests
//
//  Created by 林達也 on 2017/07/17.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import XCTest
@testable import AppleMusicKit

extension String: Language {}

struct Storefront: AppleMusicKit.Storefront {
    typealias Identifier = String
    typealias Language = String

    let name: String
    let defaultLanguageTag: String
    let supportedLanguageTags: [String]

    init(id: Identifier, defaultLanguageTag: String, name: String, supportedLanguageTags: [String]) throws {
        self.name = name
        self.defaultLanguageTag = defaultLanguageTag
        self.supportedLanguageTags = supportedLanguageTags
    }
}
struct Song: AppleMusicKit.Song {
    typealias Identifier = String
    typealias Artwork = AppleMusicKitTests.Artwork
    typealias EditorialNotes = AppleMusicKitTests.EditorialNotes
    typealias PlayParameters = AppleMusicKitTests.PlayParameters
    typealias Preview = AppleMusicKitTests.Preview

    let name: String
    let artwork: Artwork

    init(id: Identifier, albumName: String?, artistName: String, artwork: Artwork, composerName: String?, contentRating: String?, discNumber: Int, durationInMillis: Int?, editorialNotes: EditorialNotes?, genreNames: [String], isrc: String, movementCount: Int?, movementName: String?, movementNumber: Int?, name: String, playParams: PlayParameters?, previews: [Preview], releaseDate: Date, trackNumber: Int, url: URL, workName: String?) throws {
        self.name = name
        self.artwork = artwork
    }
}
struct MusicVideo: AppleMusicKit.MusicVideo {
    typealias Identifier = String
    typealias Artwork = AppleMusicKitTests.Artwork
    typealias EditorialNotes = AppleMusicKitTests.EditorialNotes
    typealias PlayParameters = AppleMusicKitTests.PlayParameters
    typealias Preview = AppleMusicKitTests.Preview

    let name: String
    let artwork: Artwork

    init(id: Identifier, albumName: String?, artistName: String, artwork: Artwork, contentRating: String?, durationInMillis: Int?, editorialNotes: EditorialNotes?, genreNames: [String], isrc: String, name: String, playParams: PlayParameters?, previews: [Preview], releaseDate: Date, trackNumber: Int?, url: URL, videoSubType: String?, hasHDR: Bool, has4K: Bool) throws {
        self.name = name
        self.artwork = artwork
    }
}
struct Album: AppleMusicKit.Album {
    typealias Identifier = String
    typealias Artwork = AppleMusicKitTests.Artwork
    typealias EditorialNotes = AppleMusicKitTests.EditorialNotes
    typealias PlayParameters = AppleMusicKitTests.PlayParameters

    let name: String

    init(id: Identifier, albumName: String?, artistName: String, artwork: Artwork?, contentRating: String?, copyright: String?, editorialNotes: EditorialNotes?, genreNames: [String], isComplete: Bool, isSingle: Bool, name: String, playParams: PlayParameters?, recordLabel: String, releaseDate: Date, trackCount: Int, url: URL, isMasteredForItunes: Bool) throws {
        self.name = name
        print(artwork)
    }
}
struct Artist: AppleMusicKit.Artist {
    typealias Identifier = String
    typealias EditorialNotes = AppleMusicKitTests.EditorialNotes

    let name: String

    init(id: Identifier, editorialNotes: EditorialNotes?, genreNames: [String], name: String, url: URL) throws {
        self.name = name
    }
}
struct Genre: AppleMusicKit.Genre {
    typealias Identifier = String
    let name: String

    init(id: Identifier, name: String) throws {
        self.name = name
    }
}
struct Playlist: AppleMusicKit.Playlist {
    typealias Identifier = String
    typealias Artwork = AppleMusicKitTests.Artwork
    typealias EditorialNotes = AppleMusicKitTests.EditorialNotes
    typealias PlayParameters = AppleMusicKitTests.PlayParameters

    init(id: Identifier, artwork: Artwork?, curatorName: String?, description: EditorialNotes?, lastModifiedDate: Date, name: String, playlistType: PlaylistType, playParams: PlayParameters?, url: URL) throws {
    }
}
struct Curator: AppleMusicKit.Curator {
    typealias Identifier = String
    typealias Artwork = AppleMusicKitTests.Artwork
    typealias EditorialNotes = AppleMusicKitTests.EditorialNotes

    init(id: Identifier, artwork: Artwork, editorialNotes: EditorialNotes?, name: String, url: URL) throws {
        print(artwork, editorialNotes)
    }
}
struct Station: AppleMusicKit.Station {
    typealias Identifier = String
    typealias Artwork = AppleMusicKitTests.Artwork
    typealias EditorialNotes = AppleMusicKitTests.EditorialNotes

    let name: String
    let isLive: Bool

    init(id: Identifier, artwork: Artwork, durationInMillis: Int?, editorialNotes: EditorialNotes?, episodeNumber: Int?, isLive: Bool, name: String, url: URL) throws {
        self.name = name
        self.isLive = isLive
    }
}
struct Artwork: AppleMusicKit.Artwork {
    init(width: Int, height: Int, url: String, colors: (bgColor: String, textColor1: String, textColor2: String, textColor3: String, textColor4: String)?) throws {
        print(colors)
    }
}
struct EditorialNotes: AppleMusicKit.EditorialNotes {
    init(standard: String, short: String) throws {
    }
}
struct PlayParameters: AppleMusicKit.PlayParameters {
    init(id: String, kind: String) throws {
    }
}
struct Preview: AppleMusicKit.Preview {
    typealias Artwork = AppleMusicKitTests.Artwork

    init(artwork: Artwork?, url: URL) throws {
    }
}

typealias GetSong = AppleMusicKit.GetSong<Song, Album, Artist, Genre, Storefront>
typealias GetMusicVideo = AppleMusicKit.GetMusicVideo<MusicVideo, Album, Artist, Genre, Storefront>
typealias GetAlbum = AppleMusicKit.GetAlbum<Album, Song, MusicVideo, Artist, Storefront>
typealias GetMultipleAlbums = AppleMusicKit.GetMultipleAlbums<Album, Song, MusicVideo, Artist, Storefront>
typealias GetArtist = AppleMusicKit.GetArtist<Artist, Album, Genre, Storefront>
typealias GetPlaylist = AppleMusicKit.GetPlaylist<Playlist, Curator, Song, MusicVideo, Storefront>
typealias GetCharts = AppleMusicKit.GetCharts<Song, MusicVideo, Album, Genre, Storefront>
typealias SearchResources = AppleMusicKit.SearchResources<Song, MusicVideo, Album, Artist, Storefront>
typealias GetStorefront = AppleMusicKit.GetStorefront<Storefront>
typealias GetMultipleStorefronts = AppleMusicKit.GetMultipleStorefronts<Storefront>
typealias GetAllStorefronts = AppleMusicKit.GetAllStorefronts<Storefront>
typealias GetUserStorefront = AppleMusicKit.GetUserStorefront<Storefront>
typealias GetMultipleStations = AppleMusicKit.GetMultipleStations<Station, Storefront>
typealias GetTopChartGenres = AppleMusicKit.GetTopChartGenres<Genre, Storefront>

private class BundleTarget {}

func load(_ filename: String) throws -> Data {
    let path = Bundle(for: BundleTarget.self).path(forResource: filename, ofType: "json")
    return try Data(contentsOf: URL(fileURLWithPath: path!))
}

extension Array where Element: Hashable {
    var set: Set<Element> {
        return Set(self)
    }
}

extension XCTestCase {
    func XCTAssertDecodeNoThrow<Response: Decodable>(class: Response.Type, fixture: String, file: StaticString = #file, line: UInt = #line, _ expression: (Response) throws -> Void = { _ in }) throws {
        let json = try AppleMusicKitTests.load(fixture)
        do {
            try expression(decode(json, urlResponse: {
                HTTPURLResponse(url: URL(string: "https://api.music.apple.com")!,
                                statusCode: 200,
                                httpVersion: "HTTP/1.1",
                                headerFields: nil)
            }()))
        } catch {
            XCTFail("\(error)", file: file, line: line)
        }
    }
}
