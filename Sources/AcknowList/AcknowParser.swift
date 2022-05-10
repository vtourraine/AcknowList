//
// AcknowParser.swift
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

public protocol AcknowFileDecoder {

    func decode(from url: URL) throws -> AcknowList
}

/// Responsible for parsing acknowledgements files.
open class AcknowParser {

    /**
     Finds the first link (URL) in a given string.

     - parameter text: The string to parse.

     - returns: The first link found, or `nil` if no link can be found.
     */
    class func firstLink(in text: String) -> URL? {
        let types: NSTextCheckingResult.CheckingType = [.link]

        guard let linkDetector = try? NSDataDetector(types: types.rawValue),
            let firstLink = linkDetector.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) else {
                return nil
        }

        return firstLink.url
    }

    open class func sorted(_ acknowledgements: [Acknow]) -> [Acknow] {
        return acknowledgements.sorted { ack1, ack2 in
            let result = ack1.title.localizedCompare(ack2.title)
            return (result == ComparisonResult.orderedAscending)
        }
    }

    /**
     Filters out all premature line breaks (i.e. removes manual wrapping).

     - parameter text: The text to process.

     - returns: The text without the premature line breaks.
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
}
