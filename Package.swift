// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "AppleMusicKit",
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
