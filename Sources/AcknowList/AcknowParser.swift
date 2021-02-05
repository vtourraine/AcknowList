//
// AcknowParser.swift
//
// Copyright (c) 2015-2021 Vincent Tourraine (https://www.vtourraine.net)
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

/// Responsible for parsing a CocoaPods acknowledgements plist file.
open class AcknowParser {

    /// The root dictionary from the loaded plist file.
    let rootDictionary: [String: AnyObject]

    /**
     Initializes the `AcknowParser` instance with a plist path.

     - parameter plistPath: The path to the acknowledgements plist file.

     - returns: The new `AcknowParser` instance.
     */
    public init(plistPath: String) {
        let root = NSDictionary(contentsOfFile: plistPath)
        if let root = root, root is [String: AnyObject] {
            self.rootDictionary = root as! [String: AnyObject]
        }
        else {
            self.rootDictionary = Dictionary()
        }
    }

    /**
     Parses the header and footer values.

     - return: a tuple with the header and footer values.
     */
    open func parseHeaderAndFooter() -> (header: String?, footer: String?) {
        let preferenceSpecifiers: AnyObject? = self.rootDictionary["PreferenceSpecifiers"]

        if let preferenceSpecifiers = preferenceSpecifiers, preferenceSpecifiers is [AnyObject] {
            let preferenceSpecifiersArray = preferenceSpecifiers as! [AnyObject]
            if let headerItem = preferenceSpecifiersArray.first,
                let footerItem = preferenceSpecifiersArray.last,
                let headerText = headerItem["FooterText"], headerItem is [String: String],
                let footerText = footerItem["FooterText"], footerItem is [String: String] {
                    return (headerText as! String?, footerText as! String?)
            }
        }

        return (nil, nil)
    }

    /**
     Parses the array of acknowledgements.

     - return: an array of `Acknow` instances.
     */
    open func parseAcknowledgements() -> [Acknow] {
        let preferenceSpecifiers: AnyObject? = rootDictionary["PreferenceSpecifiers"]

        if let preferenceSpecifiers = preferenceSpecifiers, preferenceSpecifiers is [AnyObject] {
            let preferenceSpecifiersArray = preferenceSpecifiers as! [AnyObject]

            // Remove the header and footer
            let ackPreferenceSpecifiers = preferenceSpecifiersArray.filter({ (object: AnyObject) -> Bool in
                if let firstObject = preferenceSpecifiersArray.first,
                    let lastObject = preferenceSpecifiersArray.last {
                        return (object.isEqual(firstObject) == false && object.isEqual(lastObject) == false)
                }
                return true
            })

            let acknowledgements = ackPreferenceSpecifiers.map({
                (preferenceSpecifier: AnyObject) -> Acknow in
                if let title = preferenceSpecifier["Title"] as! String?,
                    let text = preferenceSpecifier["FooterText"] as! String? {
                    let textWithoutNewlines = AcknowParser.filterOutPrematureLineBreaks(text: text)
                        return Acknow(title: title, text: textWithoutNewlines, license: preferenceSpecifier["License"] as? String)
                }
                else {
                    return Acknow(title: "", text: "", license: nil)
                }
            })

            return acknowledgements
        }

        return []
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

    /**
     Finds the first link (URL) in a given string.

     @param text The string to parse.

     @return The first link found, or `nil` if no link can be found.
     */
    class func firstLink(in text: String) -> URL? {
        let types: NSTextCheckingResult.CheckingType = [.link]

        guard let linkDetector = try? NSDataDetector(types: types.rawValue),
            let firstLink = linkDetector.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) else {
                return nil
        }

        return firstLink.url
    }
}
