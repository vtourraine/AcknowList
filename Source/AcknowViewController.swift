//
// AcknowViewController.swift
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

import UIKit

/// Subclass of `UIViewController` that displays a single acknowledgement.
open class AcknowViewController: UIViewController {

    /// The main text view.
    open var textView: UITextView?

    /// The represented acknowledgement.
    var acknowledgement: Acknow?

    /**
     Initializes the `AcknowViewController` instance with an acknowledgement.

     - parameter acknowledgement: The represented acknowledgement.

     - returns: The new `AcknowViewController` instance.
     */
    public init(acknowledgement: Acknow) {
        super.init(nibName: nil, bundle: nil)

        self.title = acknowledgement.title
        self.acknowledgement = acknowledgement
    }

    /**
     Initializes the `AcknowViewController` instance with a coder.

     - parameter aDecoder: The archive coder.

     - returns: The new `AcknowViewController` instance.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.acknowledgement = Acknow(title: "", text: "", license: nil)
    }

    // MARK: - View lifecycle

    /// Called after the controller's view is loaded into memory.
    open override func viewDidLoad() {
        super.viewDidLoad()

        let textView = UITextView(frame: view.bounds)
        textView.alwaysBounceVertical = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.isEditable = false
        textView.dataDetectorTypes = .link

        view.backgroundColor = UIColor.white
        view.addSubview(textView)

        self.textView = textView

        if #available(iOS 9.0, *) {
            textView.translatesAutoresizingMaskIntoConstraints = false

            let marginGuide = view.readableContentGuide
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
                textView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
                textView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor)])
        }
        else {
            textView.textContainerInset = UIEdgeInsetsMake(12, 10, 12, 10)
        }
    }

    /// Called to notify the view controller that its view has just laid out its subviews.
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Need to set the textView text after the layout is completed, so that the content inset and offset properties can be adjusted automatically.
        if let acknowledgement = self.acknowledgement {
            textView?.text = acknowledgement.text
        }
    }
}
