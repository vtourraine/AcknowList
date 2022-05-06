//
// AcknowPackageDecoder.swift
//
// Copyright (c) 2015-2022 Vincent Tourraine (https://www.vtourraine.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// Responsible for parsing a Swift Package Manager “resolved” package file.
open class AcknowPackageDecoder: AcknowFileDecoder {
    
    public init() {
    }

    public func decode(from url: URL) throws -> AcknowList {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        if let root = try? decoder.decode(JSONV1Root.self, from: data) {
            let acknows = root.object.pins.map { Acknow(title: $0.package, repository: URL(string: $0.repositoryURL)) }
            return AcknowList(headerText: nil, acknowledgements: acknows, footerText: nil)
        }

        let root = try decoder.decode(JSONV2Root.self, from: data)
        let acknows =  root.pins.map { Acknow(title: $0.identity, repository: URL(string: $0.location)) }
        return AcknowList(headerText: nil, acknowledgements: acknows, footerText: nil)
    }
    
    struct K {
        static let defaultFileName = "Package"
        static let defaultFileExtension = "resolved"
    }

    /**
     Parses the acknowledgements from `Package.resolved`.

     - returns: an array of `Acknow` instances, or `nil` if no valid `Package.resolved` was found.
     */
    open class func defaultAcknowledgements() -> AcknowList? {
        guard let url = Bundle.main.url(forResource: K.defaultFileName, withExtension: K.defaultFileExtension) else {
            print("** AcknowList Warning **")
            print("`\(K.defaultFileName).\(K.defaultFileExtension)` file not found.")
            print("Please add `[appName].xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` to your main target.")
            return nil
        }

        return try? AcknowPackageDecoder().decode(from: url)
    }
    
    // MARK: - JSON format

    struct JSONV1Root: Codable {
        let object: JSONV1Object
        let version: Int
    }

    struct JSONV1Object: Codable {
        let pins: [JSONV1Pin]
    }

    struct JSONV1Pin: Codable {
        let package: String
        let repositoryURL: String
    }

    struct JSONV2Root: Codable {
        let pins: [JSONV2Pin]
        let version: Int
    }

    struct JSONV2Pin: Codable {
        let identity: String
        let location: String
    }
}
