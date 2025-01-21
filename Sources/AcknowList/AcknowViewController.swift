//
// AcknowViewController.swift
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

#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit

/// Subclass of `UIViewController` that displays a single acknowledgement.
@available(iOS 9.0.0, tvOS 9.0.0, visionOS 1.0.0, *)
open class AcknowViewController: UIViewController {

    /// The main text view.
    open var textView: UITextView?

    /// The represented acknowledgement.
    open var acknowledgement: Acknow?

    /**
     Initializes the `AcknowViewController` instance with an acknowledgement.
     - Parameter acknowledgement: The represented acknowledgement.
     - Returns: The new `AcknowViewController` instance.
     */
    public init(acknowledgement: Acknow) {
        super.init(nibName: nil, bundle: nil)

        self.title = acknowledgement.title
        self.acknowledgement = acknowledgement
    }

    /**
     Initializes the `AcknowViewController` instance with a coder.
     - Parameter aDecoder: The archive coder.
     - Returns: The new `AcknowViewController` instance.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View lifecycle

    let DefaultMarginTopBottom: CGFloat = 20
    let DefaultMarginLeftRight: CGFloat = 10

    /// Called after the controller's view is loaded into memory.
    open override func viewDidLoad() {
        super.viewDidLoad()

        let textView = UITextView(frame: view.bounds)
        textView.alwaysBounceVertical = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        #if os(iOS)
            textView.isEditable = false
            textView.dataDetectorTypes = .link
        #elseif os(tvOS)
            textView.isUserInteractionEnabled = true
            textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        #endif
        textView.textContainerInset = UIEdgeInsets(top: DefaultMarginTopBottom, left: DefaultMarginLeftRight, bottom: DefaultMarginTopBottom, right: DefaultMarginLeftRight)
        view.addSubview(textView)

        self.textView = textView
    }

    /// Called to notify the view controller that its view has just laid out its subviews.
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let textView = textView {
            updateTextViewInsets(textView)
        }

        // Need to set the textView text after the layout is completed, so that the content inset and offset properties can be adjusted automatically.
        if let acknowledgement = acknowledgement {
            textView?.text = acknowledgement.text
        }
    }

    @available(iOS 11.0, tvOS 11.0, *) open override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()

        if let textView = textView {
            updateTextViewInsets(textView)
        }
    }

    func updateTextViewInsets(_ textView: UITextView) {
        textView.textContainerInset = UIEdgeInsets(top: DefaultMarginTopBottom, left: view.readableContentGuide.layoutFrame.minX, bottom: DefaultMarginTopBottom, right: view.frame.width - view.readableContentGuide.layoutFrame.maxX)
    }
}

#endif
