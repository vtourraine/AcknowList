// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AcknowList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(name: "AcknowList", targets: ["AcknowList"])
    ],
    targets: [
        .target(
            name: "AcknowList",
            path: "Sources",
            resources: [.process("Resources")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
