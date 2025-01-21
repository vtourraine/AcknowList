# Changelog

## 3.3.0 (work in progress)

- Add initializer to `AcknowListSwiftUI` to load default acknow list, by Tisfeng (@tisfeng)
- Update `AcknowViewController.acknowledgement` to `open` access level for customizability, by cheshire (@cheshire0105)


## 3.2.0 (11 June 2024)

- Add visionOS support


## 3.1.0 (25 January 2024)

- Add `GitHubAPI` to get licenses from GitHub API
- Update `AcknowListViewController` and `AcknowListSwiftUIView` to get missing licenses from GitHub API, with new `canFetchLicenseFromGitHub` property to disable this behavior
- Add `URL` extension with `openWithDefaultBrowser()` function to fix opening URLs on macOS with SwiftUI


## 3.0.1 (24 November 2022)

- Update `AcknowListSwiftUIView` to fix navigation to repository URL
- Add `AcknowListRowSwiftUIView`


## 3.0.0 (17 September 2022)

- Add `AcknowList` struct to represent list model
- Add `AcknowPackageDecoder` to parse “Package.resolved” files (Swift Package Manager)
- Refactor plist file parser into `AcknowPodDecoder`
- Refactor `AcknowParser` to manage parsing different file types
- Refactor file paths parameters (`String`) into file URLs (`URL`) instead
- Update `AcknowListViewController` to load acknowledgements from “Package.resolved” by default


## 2.1.1 (15 June 2022)

- Follow readable content guides
- Fix Swift Package Manager warning (exlude DocC folder)


## 2.1.0 (12 January 2022)

- Add SwiftUI interface (supports iOS/tvOS/watchOS/macOS)
- Add DocC resources
- Fix Xcode 13 support, by Thomas Mellenthin (@melle) and Francesc Bruguera (@ifrins)
- Update CocoaPods and Swift Package Manager support to require iOS 13/tvOS 13, necessary to support SwiftUI


## 2.0.3 (21 September 2021)

- Update `AcknowListViewController` default initializer implementatoin to fix Xcode 13 support


## 2.0.2 (17 September 2021)

- Update `AcknowListViewController` to remove Objective-C compatibility, fixing Xcode 13 support


## 2.0.1 (26 April 2021)

- Update `AcknowListViewController` to make initializers available with Objective-C
- Fix header/footer layout when resizing `AcknowListViewController`


## 2.0.0 (15 March 2021)

- Update `AcknowListViewController` to detect URLs in header and footer
- Update `AcknowListViewController` to make `acknowledgements` property non-optional
- Update `AcknowListViewController` initializers
    - Add optional table view style parameter, by Matt Croxson (@Lumus)
    - Add initializer with array of `Acknow`
    - Rename plist path parameter
    - Remove initializer with multiple plist paths
- Improve Swift Package Manager support
    - Support SPM localized resources, by Patrick (@iDevelopper)
    - Add SPM test target
    - Add SPM example project
    - Move sources, tests, and resources to follow SPM guidelines
- Add CocoaPods example project
- Update supported platforms to iOS 9 and more recent


## 1.9.5 (17 September 2020)

- Fix header/footer layout when building with iOS 14 SDK


## 1.9.4 (15 April 2020)

- Fix `AcknowListViewController` initializers access level, by Kevin Mitchell Jr (@klmitchell2)
- Improve Dark Mode support


## 1.9.3 (9 January 2020)

- Fix scrollable acknowledgement details on tvOS, by Jochen Holzer (@Wooder)


## 1.9.2 (7 October 2019)

- Add Swift Package Manager support, by Curato (@curato-research), Zhu Zhiyu (@ApolloZhu)


## 1.9.1 (24 September 2019)

- Improve automatic acknowledgements detection, by Francisco Javier Trujillo Mata (@fjtrujy)
- Improve cell initialization, by Francisco Javier Trujillo Mata (@fjtrujy)


## 1.9 (3 April 2019)

- Update to Swift 5, by Oscar Gorog (@OkiRules)


## 1.8 (4 December 2018)

- Add `AcknowListViewController` initializer for multiple plist paths, by Kieran Harper (@KieranHarper)
- Improve Dynamic Type support


## 1.7 (14 September 2018)

- Update to Swift 4.2
- Filter out manual line wrapping from licenses text, by Albert Zhang (@azhang66)


## 1.6.1 (25 June 2018)

- Fix text view inset on `AcknowViewController` (support layout margins, safe area insets)
- Remove support for “readable content guide” on `AcknowViewController`


## 1.6 (20 March 2018)

- Add tvOS support, by Tobias Tiemerding (@honkmaster)


## 1.5 (23 January 2018)

- Add convenience initializer with file name for `AcknowViewController`
- Update `AcknowViewController.init` with default plist file name based on bundle name (`Pods-#BUNDLE-NAME#-acknowledgements.plist`), by Simon Bromberg (@simonbromberg)
- Update `AcknowListViewController` with new `UIApplication` “open URL” method for iOS 10, by Morten Gregersen (@mortengregersen)


## 1.4 (15 September 2017)

- Support “readable content guide” on `AcknowViewController`
- Fix iPhone X layout


## 1.3 (13 September 2017)

- Update to Swift 4


## 1.2.1 (12 July 2017)

- Update `Acknow` initializer to `public` access level, by Chope (@yoonhg84)


## 1.2 (20 October 2016)

- Add `license` property on `Acknow`, by Naoto Kaneko (@naoty)
- Update classes to `open` access level, by Oliver Ziegler (@oliverziegler) and Naoto Kaneko (@naoty)


## 1.1 (19 September 2016)

- Update to Swift 3


## 1.0.2 (19 September 2016)

- Update to Swift 2.3


## 1.0.1 (5 September 2016)

- Mark `headerText` and `footerText` properties as public, by Bas Broek (@basthomas)


## 1.0 (11 May 2016)

- Ready for CocoaPods 1.0.0


## 0.3.2 (1 May 2016)

- Improve documentation


## 0.3.1 (30 April 2016)

- Improve documentation


## 0.3 (17 April 2016)

- Add localization bundle for default header and footer, by James White (@gerbiljames)
- Refactor localization to new `AcknowLocalization` class
- Updated to Swift 2.2 (requires Xcode 7.3), by James White (@gerbiljames)
- Fixed `AcknowListViewController` footer margin, by James White (@gerbiljames)
- Fixed project URL in warning message, by James White (@gerbiljames)


## 0.2.2 (3 March 2016)

- Fixed selector for CocoaPods website


## 0.2.1 (30 January 2016)

- Fixed selector for dismiss bar button item


## 0.2 (27 January 2016)

- Fixed list sort order
- Updated default footer text for CocoaPods 1.0
- Updated CocoaPods URL for CocoaPods 1.0


## 0.1 (22 September 2015)

- Initial release
