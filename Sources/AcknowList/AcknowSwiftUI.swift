//
// AcknowSwiftUI.swift
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

import SwiftUI

@available(iOS 13.0.0, macOS 10.15.0, watchOS 6.0.0, tvOS 13.0.0, *)
public struct AcknowSwiftUIView: View {
    public var acknowledgement: Acknow

    public init(acknowledgement: Acknow) {
        self.acknowledgement = acknowledgement
    }

    public var body: some View {
        ScrollView {
            Text(acknowledgement.text)
                .padding()
        }
        .navigationBarTitle(Text(AcknowLocalization.localizedTitle()))
    }
}

@available(iOS 13.0.0, macOS 10.15.0, watchOS 7.0.0, tvOS 13.0.0, *)
struct AcknowSwiftUI_Previews: PreviewProvider {
    static let license = """
    Copyright (c) 2015-2021 Vincent Tourraine (https://www.vtourraine.net)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
    """
    static let ack = Acknow(title: "License", text: license)

    static var previews: some View {
        NavigationView {
            AcknowSwiftUIView(acknowledgement: ack)
        }

        NavigationView {
            AcknowSwiftUIView(acknowledgement: ack)
        }
        .previewDevice(PreviewDevice(rawValue: "Apple TV 4K"))
    }
}
