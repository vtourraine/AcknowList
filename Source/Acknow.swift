//
// Acknow.swift
//
// Copyright (c) 2015-2017 Vincent Tourraine (http://www.vtourraine.net)
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


/// Represents a single acknowledgement.
public struct Acknow {

    /// The acknowledgement title (for instance: the pod’s name).
    public let title: String

    /// The acknowledgement body text (for instance: the pod’s license).
    public let text: String

    /// The acknowledgement license (for instance the pod’s license type).
    public let license: String?

    /// Returns an object initialized from the given parameters.
    ///
    /// - Parameters:
    ///   - title: The acknowledgement title (for instance: the pod’s name).
    ///   - text: The acknowledgement body text (for instance: the pod’s license).
    ///   - license: The acknowledgement license (for instance the pod’s license type).
    public init(title: String, text: String, license: String? = nil) {
        self.title = title
        self.text = text
        self.license = license
    }
}
