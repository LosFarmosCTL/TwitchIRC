// swift-tools-version:6.4

import PackageDescription

let package = Package(
    name: "TwitchIRC",
    products: [
        .library(
            name: "TwitchIRC",
            targets: ["TwitchIRC"]
        ),
    ],
    targets: [
        .target(name: "TwitchIRC"),
        .testTarget(
            name: "TwitchIRCTests",
            dependencies: ["TwitchIRC"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
