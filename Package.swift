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
            exclude: ["AcknowList.docc"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AcknowListTests",
            dependencies: ["AcknowList"],
            exclude: ["Info.plist"],
            resources: [
                .copy("Resources/Pods-acknowledgements-RegexTesting.plist"),
                .copy("Resources/Pods-acknowledgements.plist"),
                .copy("Resources/RegexTesting-GroundTruth-Charts.txt"),
                .copy("Resources/RegexTesting-GroundTruth-TYPFontAwesome.txt"),
                .copy("Resources/Pods-acknowledgements-multi.plist"),
                .copy("Resources/RegexTesting-GroundTruth-Alamofire.txt"),
                .copy("Resources/RegexTesting-GroundTruth-TPKeyboardAvoiding.txt"),
                .copy("Resources/RegexTesting-GroundTruth-pop.txt"),
                .copy("Resources/Package-version-1.resolved"),
                .copy("Resources/Package-version-2.resolved"),
                .copy("Resources/Package.resolved"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
