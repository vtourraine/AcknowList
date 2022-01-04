// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AcknowList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .watchOS(.v7), .macOS(.v10_15)
    ],
    products: [
        .library(name: "AcknowList", targets: ["AcknowList"])
    ],
    targets: [
        .target(
            name: "AcknowList",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AcknowListTests",
            dependencies: ["AcknowList"],
            exclude: ["Info.plist", "Resources"],
            resources: [
                .copy("Pods-acknowledgements-RegexTesting.plist"),
                .copy("Pods-acknowledgements.plist"),
                .copy("RegexTesting-GroundTruth-Charts.txt"),
                .copy("RegexTesting-GroundTruth-TYPFontAwesome.txt"),
                .copy("Pods-acknowledgements-multi.plist"),
                .copy("RegexTesting-GroundTruth-Alamofire.txt"),
                .copy("RegexTesting-GroundTruth-TPKeyboardAvoiding.txt"),
                .copy("RegexTesting-GroundTruth-pop.txt")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
