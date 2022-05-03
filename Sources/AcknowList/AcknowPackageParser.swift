//
// AcknowPackageParser.swift
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

/// Responsible for parsing a Swift Package Manager `Package.resolved` file.
open class AcknowPackageParser {
    
    let fileData: Data

    /**
     Initializes the `AcknowPackageParser` instance with a `Package.resolved` file path.

     - parameter url: The URL  to the `Package.resolved` file.

     - returns: The new `AcknowPackageParser` instance.
     */
    public init(url: URL) throws {
        self.fileData = try Data(contentsOf: url)
    }
    
    /**
     Parses the array of acknowledgements.

     - return: an array of `Acknow` instances.
     */
    open func parseAcknowledgements() -> [Acknow] {
        let decoder = JSONDecoder()
        if let root = try? decoder.decode(JSONV1Root.self, from: fileData) {
            return root.object.pins.map { Acknow(title: $0.package, repository: URL(string: $0.repositoryURL)) }
        }
        else if let root = try? decoder.decode(JSONV2Root.self, from: fileData) {
            return root.pins.map { Acknow(title: $0.identity, repository: URL(string: $0.location)) }
        }
        else {
            return []
        }
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
