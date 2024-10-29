//
// AcknowListSwiftUI.swift
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

extension Acknow: Identifiable {
    public var id: String {
        get {
            title
        }
    }
}

/// View that displays a list of acknowledgements.
@available(iOS 13.0.0, macOS 10.15.0, watchOS 7.0.0, tvOS 13.0.0, *)
public struct AcknowListSwiftUIView: View {
    @Environment(\._isAcknowListSwiftUIViewNavigationTitleHidden) private var isAcknowListSwiftUIViewNavigationTitleHidden

    /// The represented array of `Acknow`.
    public var acknowledgements: [Acknow] = []

    /// Header text to be displayed above the list of the acknowledgements.
    public var headerText: String?

    /// Footer text to be displayed below the list of the acknowledgements.
    public var footerText: String?

    public init(acknowledgements: [Acknow], headerText: String? = nil, footerText: String? = nil) {
        self.acknowledgements = acknowledgements
        self.headerText = headerText
        self.footerText = footerText
    }

    public init(plistPath: String) {
        let parser = AcknowParser(plistPath: plistPath)
        let headerFooter = parser.parseHeaderAndFooter()
        let header: String?
        let footer = headerFooter.footer

        if headerFooter.header != AcknowParser.DefaultHeaderText {
            header = headerFooter.header
        }
        else {
            header = nil
        }

        self.init(acknowledgements: parser.parseAcknowledgements(), headerText: header, footerText: footer)
    }

    struct HeaderFooter: View {
        let text: String?

        var body: some View {
            if let text = text {
                Text(text)
            }
            else {
                Text("")
            }
        }
    }

    public var body: some View {
        #if os(iOS) || os(tvOS)
        if isAcknowListSwiftUIViewNavigationTitleHidden {
            list
            .listStyle(GroupedListStyle())
        } else {
            list
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(AcknowLocalization.localizedTitle()))
        }
        #else
        list
        #endif
    }

    @ViewBuilder
    private var list: some View {
        List {
            Section(header: HeaderFooter(text: headerText), footer: HeaderFooter(text: footerText)) {
                ForEach (acknowledgements) { acknowledgement in
                    NavigationLink(destination: AcknowSwiftUIView(acknowledgement: acknowledgement)) {
                        Text(acknowledgement.title)
                    }
                }
            }
        }
    }

    @ViewBuilder
    public func navigationTitle(isHidden: Bool) -> some View {
        environment(\._isAcknowListSwiftUIViewNavigationTitleHidden, isHidden)
    }
}

@available(iOS 13.0.0, macOS 10.15.0, watchOS 7.0.0, tvOS 13.0.0, *)
struct AcknowListSwiftUI_Previews: PreviewProvider {
    static let license = """
        Copyright (c) 2015-2021 Vincent Tourraine (https://www.vtourraine.net)

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    """
    static let acks = [Acknow(title: "Title 1", text: license),
                       Acknow(title: "Title 2", text: license),
                       Acknow(title: "Title 3", text: license)]

    static var previews: some View {
        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks)
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 12"))

        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "Test Header", footerText: "Test Footer")
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        
        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "Test Header", footerText: "Test Footer")
        }
        .previewDevice(PreviewDevice(rawValue: "Apple TV 4K"))

        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "Test Header", footerText: "Test Footer")
        }
        .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))

        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "Test Header", footerText: "Test Footer")
        }
        .previewDevice(PreviewDevice(rawValue: "Mac"))
    }
}

// MARK: - Style
private struct _IsAcknowListSwiftUIViewNavigationTitleHiddenEnvironmentKey: EnvironmentKey {
    fileprivate static let defaultValue: Bool = false
}

extension EnvironmentValues {
    fileprivate var _isAcknowListSwiftUIViewNavigationTitleHidden: Bool {
        get { self[_IsAcknowListSwiftUIViewNavigationTitleHiddenEnvironmentKey.self] }
        set { self[_IsAcknowListSwiftUIViewNavigationTitleHiddenEnvironmentKey.self] = newValue }
    }
}
