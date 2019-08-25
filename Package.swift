// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "AppleMusicKit",
    platforms: [
      .iOS(.v10), .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "AppleMusicKit",
            targets: ["AppleMusicKit"]
        )
    ],
    targets: [
        .target(
            name: "AppleMusicKit",
            path: "Sources"
        ),
    ]
)
