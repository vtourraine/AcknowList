//
// ViewController.swift
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
import AcknowList

class ViewController: UIViewController {

    @IBAction func pushAcknowList(_ sender: Any) {
        let viewController = AcknowListViewController()

        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func pushThemedAcknowList(_ sender: Any) {
        let viewController = AcknowListViewController()

        viewController.title = "Customized Acknowledgements Title"

        viewController.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.magenta, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)]

        viewController.footerTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)]

        viewController.backgroundColor = .black

        viewController.licenceCellBackgroundColor = .lightGray
        viewController.licenceCellHighlightColor = .orange

        viewController.licenceCellFont = UIFont.systemFont(ofSize: 40)
        viewController.licenceCellFontColor = .white
        viewController.licenceCellFontHighlightColor = .yellow

        viewController.licenceDetailViewBackgroundColor = .black
        viewController.licenceDetailViewFont = UIFont.systemFont(ofSize: 30)
        viewController.licenceDetailViewFontColor = .cyan

        navigationController?.pushViewController(viewController, animated: true)
    }
}
