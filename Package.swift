// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "swift-quiz",
    platforms: [
      .iOS(.v8),
      .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "SwiftQuiz",
            targets: ["SwiftQuiz"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/rwbutler/Hash",
            from: "1.4.0"
        ),
        .package(
            url: "https://github.com/rwbutler/LetterCase",
            from: "1.3.1"
        ),
        .package(
            url: "https://github.com/krisk/fuse-swift",
            from: "1.4.0"
        )
    ],
    targets: [
        .target(
            name: "SwiftQuiz",
            dependencies: ["Hash", "LetterCase", "Fuse"],
            path: "code"
        )
    ]
)
