//
// AcknowParser.swift
//
// Copyright (c) 2015-2025 Vincent Tourraine (https://www.vtourraine.net)
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

/// A type that decodes acknowledgements from structured objects.
public protocol AcknowDecoder {

    /**
     Returns acknowledgements decoded from a structured object.
     - Parameter data: The acknowledgements object to decode.
     - Returns: A `AcknowList` value, if the decoder can parse the data.
     */
    func decode(from data: Data) throws -> AcknowList
}

/// Responsible for parsing acknowledgements files.
open class AcknowParser {

    // MARK: - Pods

    internal class func bundleName() -> String? {
        let infoDictionary = Bundle.main.infoDictionary
        if let cfBundleName = infoDictionary?["CFBundleName"] as? String {
            return cfBundleName
        }
        else if let cfBundleExecutable = infoDictionary?["CFBundleExecutable"] as? String {
            return cfBundleExecutable
        }
        else {
            return nil
        }
    }

    /**
     Parses the acknowledgements from the `Pods-###-acknowledgements.plist` and `Package.resolved` files in the main bundle, and merges the result.
     - Returns: a `AcknowList` instance, or `nil` if no valid file was found.
     */
    open class func defaultAcknowList() -> AcknowList? {
        let pods = defaultPods()
        let packages = defaultPackages()
        if let pods = pods, let packages = packages {
            return pods + packages
        }
        else {
            return pods ?? packages
        }
    }

    /**
     Parses the acknowledgements from the `Pods-###-acknowledgements.plist` file in the main bundle.
     - Returns: a `AcknowList` instance, or `nil` if no valid file was found.
     */
    open class func defaultPods() -> AcknowList? {
        guard let bundleName = bundleName() else {
            return nil
        }

        let plistName = "Pods-\(bundleName)-acknowledgements"

        guard let url = Bundle.main.url(forResource: plistName, withExtension: K.DefaultPods.fileExtension),
              let data = try? Data(contentsOf: url) else {
            return nil
        }

        return try? AcknowPodDecoder().decode(from: data)
    }

    // MARK: - Packages

    /**
     Parses the acknowledgements from the `Package.resolved` file in the main bundle.
     - Returns: a `AcknowList` instance, or `nil` if no valid `Package.resolved` was found.
     */
    open class func defaultPackages() -> AcknowList? {
        guard let url = Bundle.main.url(forResource: K.DefaultPackages.fileName, withExtension: K.DefaultPackages.fileExtension),
              let data = try? Data(contentsOf: url) else {
            return nil
        }

        return try? AcknowPackageDecoder().decode(from: data)
    }

    // MARK: - Parse and format

    /**
     Finds the first link (URL) in a given string.
     - Parameter text: The string to parse.
     - Returns: The first link found, or `nil` if no link can be found.
     */
    class func firstLink(in text: String) -> URL? {
        let types: NSTextCheckingResult.CheckingType = [.link]

        guard let linkDetector = try? NSDataDetector(types: types.rawValue),
            let firstLink = linkDetector.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) else {
                return nil
        }

        return firstLink.url
    }

    /**
     Filters out all premature line breaks (i.e. removes manual wrapping).
     - Parameter text: The text to process.
     - Returns: The text without the premature line breaks.
     */
    class func filterOutPrematureLineBreaks(text: String) -> String {
        // This regex replaces single newlines with spaces, while preserving multiple newlines used for formatting.
        // This prevents issues such as https://github.com/vtourraine/AcknowList/issues/41
        //
        // The issue arises when licenses contain premature line breaks in the middle of a sentance, often used
        // to limit license texts to 80 characters. When applied on an iPad, the resulting licenses are misaligned.
        //
        // The expression (?<=.)(\h)*(\R)(\h)*(?=.) can be broken down as:
        //
        //    (?<=.)  Positive lookbehind matching any non-newline character (matches but does not capture)
        //    (\h)*   Matches and captures zero or more horizontal spaces (trailing newlines)
        //    (\R)    Matches and captures any single Unicode-compliant newline character
        //    (\h)*   Matches and captures zero or more horizontal spaces (leading newlines)
        //    (?=.)   Positive lookahead matching any non-newline character (matches but does not capture)
        let singleNewLineFinder = try! NSRegularExpression(pattern: "(?<=.)(\\h)*(\\R)(\\h)*(?=.)")
        return singleNewLineFinder.stringByReplacingMatches(in: text, range: NSRange(0..<text.count), withTemplate: " ")
    }

    internal struct K {
        struct DefaultPods {
            static let fileExtension = "plist"
        }

        struct DefaultPackages {
            static let fileName = "Package"
            static let fileExtension = "resolved"
        }
    }
}
