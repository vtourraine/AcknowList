//
// AcknowViewController.swift
//
// Copyright (c) 2015-2018 Vincent Tourraine (http://www.vtourraine.net)
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
    open var textView: UITextView? {
        didSet {
            textView?.isScrollEnabled = true
            textView?.isUserInteractionEnabled = true
            textView?.showsVerticalScrollIndicator = true
            
            #if os(tvOS)
            textView?.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
            #endif

            if let font = self.font {
                textView?.font = font
            } else {
                textView?.font = UIFont.preferredFont(forTextStyle: .body)
            }

            if let fontColor = self.fontColor {
                textView!.textColor = fontColor
            }
        }
    }

    /// The views background color.
    open var backgroundColor: UIColor?

    /// The views font.
    open var font: UIFont?

    /// The views font color.
    open var fontColor: UIColor?

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

    let TopBottomDefaultMargin: CGFloat = 20
    let LeftRightDefaultMargin: CGFloat = 10

    /// Called after the controller's view is loaded into memory.
    open override func viewDidLoad() {
        super.viewDidLoad()

        let textView = UITextView(frame: view.bounds)
        textView.alwaysBounceVertical = true

        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        #if os(iOS)
            textView.isEditable = false
            textView.dataDetectorTypes = .link
            
            view.backgroundColor = UIColor.white
        #endif

        if let customBackgroundColor = backgroundColor {
           self.view.backgroundColor = customBackgroundColor
        }

        textView.textContainerInset = UIEdgeInsets.init(top: TopBottomDefaultMargin, left: LeftRightDefaultMargin, bottom: TopBottomDefaultMargin, right: LeftRightDefaultMargin)
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
        if let acknowledgement = self.acknowledgement {
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
        textView.textContainerInset = UIEdgeInsets.init(top: TopBottomDefaultMargin, left: self.view.layoutMargins.left, bottom: TopBottomDefaultMargin, right: self.view.layoutMargins.right);
    }
}
