// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "swift-quiz",
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
        )
    ],
    targets: [
        .target(
            name: "SwiftQuiz",
            dependencies: ["Hash"],
            path: "code"
        )
    ]
)
