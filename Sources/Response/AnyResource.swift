//
//  AnyResource.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public enum Track<Song: SongDecodable, MusicVideo: MusicVideoDecodable, R: Decodable>: Decodable {
    case song(Resource<Song, R>), musicVideo(Resource<MusicVideo, R>)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(ResourceType.self, forKey: .type) {
        case .songs:
            self = .song(try Resource(from: decoder))
        case .musicVideos:
            self = .musicVideo(try Resource(from: decoder))
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: c.codingPath, debugDescription: "\(#function)@\(#line)"))
        }
    }
}

public enum AnyResource<
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    MusicVideo: MusicVideoDecodable,
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    AppleCurator: AppleCuratorDecodable,
    Activity: ActivityDecodable,
    Station: StationDecodable,
    Storefront: StorefrontDecodable,
    Genre: GenreDecodable,
    Recommendation: RecommendationDecodable,
    Relationships: Decodable
>: Decodable {
    case song(Resource<Song, Relationships>)
    case album(Resource<Album, Relationships>)
    case artist(Resource<Artist, Relationships>)
    case musicVideo(Resource<MusicVideo, Relationships>)
    case playlist(Resource<Playlist, Relationships>)
    case curator(Resource<Curator, Relationships>)
    case appleCurator(Resource<AppleCurator, Relationships>)
    case activities(Resource<Activity, Relationships>)
    case station(Resource<Station, Relationships>)
    case storefront(Resource<Storefront, Relationships>)
    case genre(Resource<Genre, Relationships>)
    case recommendation(Resource<Recommendation, Relationships>)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(ResourceType.self, forKey: .type) {
        case .songs: self = .song(try Resource(from: decoder))
        case .albums: self = .album(try Resource(from: decoder))
        case .artists: self = .artist(try Resource(from: decoder))
        case .musicVideos: self = .musicVideo(try Resource(from: decoder))
        case .playlists: self = .playlist(try Resource(from: decoder))
        case .curators: self = .curator(try Resource(from: decoder))
        case .appleCurators: self = .appleCurator(try Resource(from: decoder))
        case .activities: self = .activities(try Resource(from: decoder))
        case .stations: self = .station(try Resource(from: decoder))
        case .storefronts: self = .storefront(try Resource(from: decoder))
        case .genres: self = .genre(try Resource(from: decoder))
        case .personalRecommendation: self = .recommendation(try Resource(from: decoder))
        }
    }
}
