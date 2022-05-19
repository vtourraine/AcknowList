# ``AcknowList``

Acknowledgements screen displaying a list of licenses, for example from CocoaPods dependencies.

## Overview

AcknowList displays a list of acknowledgements with customizable header and footer, tappable links, and localized default title and footer. It can automatically load and format acknowledgments from [CocoaPods](https://cocoapods.org) and Swift Package Manager files. It supports Storyboard configuration, Dark Mode, Dynatmic Type, and other accessibility features.

It includes UIKit and SwiftUI interfaces, both offering the same features and general appearance.

![Screenshot of AcknowList running on an iPhone](acknowlist.png)

## Topics

### Model

- ``Acknow``
- ``AcknowList``

### Parser

- ``AcknowParser``
- ``AcknowPackageDecoder``
- ``AcknowPodDecoder``

### Localization

- ``AcknowLocalization``

### UIKit

- ``AcknowListViewController``
- ``AcknowViewController``

### SwiftUI

- ``AcknowListSwiftUIView``
- ``AcknowSwiftUIView``
