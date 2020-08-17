// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "swift-quiz",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "swift-quiz",
            targets: ["swift-quiz"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/rwbutler/Hash",
            from: "1.4.0"
        )
    ],
    targets: [
        .target(
            name: "swift-quiz",
            dependencies: ["Hash"],
            path: "code"
        )
    ]
)
