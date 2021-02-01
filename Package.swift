// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AcknowList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9), .tvOS(.v9), .macOS(.v10_15)
    ],
    products: [
        .library(name: "AcknowList", targets: ["AcknowList"])
    ],
    targets: [
        .target(
            name: "AcknowList",
            path: "Sources",
            exclude: ["Info.plist"],
            resources: [.process("Resources")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
