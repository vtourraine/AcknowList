//
// AcknowViewController.swift
//
// Copyright (c) 2015 Vincent Tourraine (http://www.vtourraine.net)
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

/**
 Subclass of `UIViewController` that displays a single acknowledgement.
*/
public class AcknowViewController: UIViewController {

    /**
    The main text view.
    */
    public var textView: UITextView?

    /**
    The represented acknowledgement.
    */
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
        self.acknowledgement = Acknow(title: "", text: "")
    }


    // MARK: - View lifecycle

    override public func loadView() {
        let textView = UITextView(frame: CGRectZero)
        textView.alwaysBounceVertical = true;
        textView.font                 = UIFont.systemFontOfSize(17)
        textView.editable             = false
        textView.dataDetectorTypes    = UIDataDetectorTypes.Link
        textView.textContainerInset   = UIEdgeInsetsMake(12, 10, 12, 10)

        if let acknowledgement = self.acknowledgement {
            textView.text = acknowledgement.text
        }

        self.view = textView
        self.textView = textView
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let textView = self.textView {
            textView.contentOffset = CGPointMake(textView.contentInset.top, 0)
        }
    }
}
