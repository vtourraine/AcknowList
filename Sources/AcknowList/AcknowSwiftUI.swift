//
// AcknowSwiftUI.swift
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

import SwiftUI

/// View that displays a single acknowledgement.
@available(iOS 13.0.0, macOS 10.15.0, watchOS 7.0.0, tvOS 13.0.0, visionOS 1.0.0, *)
public struct AcknowSwiftUIView: View {

    /// The represented acknowledgement.
    @State public var acknowledgement: Acknow

    public var body: some View {
        #if os(macOS)
        ScrollView {
            Text(acknowledgement.title)
                .font(.title)
                .padding()
            Text(acknowledgement.text ?? "")
                .font(.body)
                .padding()
        }
        .onAppear {
            fetchLicenseIfNecessary()
        }
        #else
        ScrollView {
            Text(acknowledgement.text ?? "")
                .font(.body)
                .padding()
        }
        .navigationBarTitle(acknowledgement.title)
        .onAppear {
            fetchLicenseIfNecessary()
        }
        #endif
    }

    private func fetchLicenseIfNecessary() {
        guard acknowledgement.text == nil,
              let repository = acknowledgement.repository,
              GitHubAPI.isGitHubRepository(repository) else {
            return
        }

        GitHubAPI.getLicense(for: repository) { result in
            switch result {
            case .success(let text):
                acknowledgement = Acknow(title: acknowledgement.title, text: text, license: acknowledgement.license, repository: acknowledgement.repository)

            case .failure:
                repository.openWithDefaultBrowser()
            }
        }
    }
}

@available(iOS 13.0.0, macOS 10.15.0, watchOS 7.0.0, tvOS 13.0.0, visionOS 1.0.0, *)
struct AcknowSwiftUI_Previews: PreviewProvider {
    static let license = """
    Copyright (c) 2015-2025 Vincent Tourraine (https://www.vtourraine.net)

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    """
    static let ack = Acknow(title: "License", text: license)

    static var previews: some View {
        NavigationView {
            AcknowSwiftUIView(acknowledgement: ack)
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 12"))

        NavigationView {
            AcknowSwiftUIView(acknowledgement: ack)
        }
        .previewDevice(PreviewDevice(rawValue: "Apple TV 4K"))

        NavigationView {
            AcknowSwiftUIView(acknowledgement: ack)
        }
        .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))

        NavigationView {
            AcknowSwiftUIView(acknowledgement: ack)
        }
        .previewDevice(PreviewDevice(rawValue: "Mac"))
    }
}
