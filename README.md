# AppleMusicKit 

## Requirements
- Swift 4.0 or later
- iOS 11 or later

## Installation

#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "sora0077/AppleMusicKit" ~> 1.0` to your Cartfile.
- Run `carthage update`.
- Link your app with `AppleMusicKit.framework`, `APIKit.framework` and `Result.framework` in `Carthage/Build`.


## Example

```swift
import AppleMusicKit

struct Storefront: StorefrontDecodable {
    typealias Identifier = String
    typealias Language = String
}

struct Song: SongDecodable {
    typealias Identifier = String
    typealias Artwork = ...
    typealias EditorialNotes = ...
    typealias PlayParameters = ...
}

struct Album: AlbumDecodable {
    ...
}

struct Artist: ArtistDecodable {
    ...
}

struct Genre: GenreDecodable {
    ...
}

typealias GetSong = AppleMusicKit.GetSong<Song, Album, Artist, Genre, Storefront>

// ------

Session.shared.authorization = Authorization(developerToken: token)

Session.shared.send(GetSong(storefront: "us", id: "900032829")) { result in
    switch result {
    case .success(let response):
        break
    case .failure(let error):
        break
    }
}

```

## Appendix

- Create Developer Token
  https://gist.github.com/sora0077/75b62f4a2a04480a90ef109a127ddbf5
