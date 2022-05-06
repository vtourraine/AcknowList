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

/// Responsible for parsing acknowledgements files.
open class AcknowParser {

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
