//
// AcknowListSwiftUI.swift
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
public struct AcknowListSwiftUIView<Content>: View where Content: View {

    /// The represented array of `Acknow`.
    public var acknowledgements: [Acknow] = []

    /// Header text to be displayed above the list of the acknowledgements.
    public var headerText: String?

    /// Footer text to be displayed below the list of the acknowledgements.
    public var footerText: String?
    /// todo
    public let content: ((Acknow) -> Content)?
    
    public init(acknowledgements: [Acknow],
                headerText: String? = nil, footerText: String? = nil, @ViewBuilder content: @escaping  (Acknow) -> Content) {
        self.acknowledgements = acknowledgements
        self.headerText = headerText
        self.footerText = footerText
        self.content = content
    }
    
    
    public init(acknowledgements: [Acknow],
                headerText: String? = nil, footerText: String? = nil) where Content == EmptyView {
        self.acknowledgements = acknowledgements
        self.headerText = headerText
        self.footerText = footerText
        self.content = nil
    }

    public init(plistPath: String) where Content == EmptyView {
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
   
    
    public init(plistPath: String, rowLabel content: @escaping (Acknow) -> Content) {
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

        self.init(acknowledgements: parser.parseAcknowledgements(), headerText: header, footerText: footer, content: content)
        
    }

    struct HeaderFooter: View {
        let text: String?

        var body: some View {
            if let text = text {
                Text(text)
            }
            else {
                EmptyView()
            }
        }
    }

    public var body: some View {
        if #available(iOS 14.0, *) {
#if os(iOS) || os(tvOS)

            List {
                Section(header: HeaderFooter(text: headerText), footer: HeaderFooter(text: footerText)) {
                    ForEach (acknowledgements) { acknowledgement in
                        NavigationLink {
                            Text(acknowledgement.text)
                        } label: {
                            if let content = content {
                                content(acknowledgement)
                            } else {
                                AcknowSwiftUIView(acknowledgement: acknowledgement)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(AcknowLocalization.localizedTitle()))
#else
            List {
                Section(header: HeaderFooter(text: headerText), footer: HeaderFooter(text: footerText)) {
                    ForEach (acknowledgements) { acknowledgement in
                        NavigationLink(destination: AcknowSwiftUIView(acknowledgement: acknowledgement)) {
                            Text(acknowledgement.title)
                        }
                    }
                }
            }
#endif
        } else {
            // Fallback on earlier versions
        }
    }
}

@available(iOS 13.0.0, macOS 10.15.0, watchOS 7.0.0, tvOS 13.0.0, *)
struct AcknowListSwiftUI_Previews: PreviewProvider {
    static let license = "Test"
    static let acks = [Acknow(title: "Title 1", text: license),
                       Acknow(title: "Title 2", text: license),
                       Acknow(title: "Title 3", text: license)]

    static var previews: some View {
        NavigationView {
                
                    AcknowListSwiftUIView(acknowledgements: acks, headerText: "TestHeader", footerText: "TestFooter") { elem in
                        HStack {
                            Text(elem.title + "test")
                            Spacer()

                        }
                        .foregroundColor(.black)
                        .padding([.leading,.trailing])
                    }
                    
                  
                
           
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 12"))

        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "TestHeader", footerText: "TestFooter")
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 12"))

        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "Test Header", footerText: "Test Footer"){ elem in
                Text(elem.title)
            }
        }
        .previewDevice(PreviewDevice(rawValue: "Apple TV 4K"))

        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "Test Header", footerText: "Test Footer"){ elem in
                Text(elem.title)
            }
        }
        .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))

        NavigationView {
            AcknowListSwiftUIView(acknowledgements: acks, headerText: "Test Header", footerText: "Test Footer"){ elem in
                Text(elem.title)
            }
        }
        .previewDevice(PreviewDevice(rawValue: "Mac"))
    }
}
