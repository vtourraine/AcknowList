//
// ViewController.swift
//
// Copyright (c) 2015-2020 Vincent Tourraine (https://www.vtourraine.net)
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

    @IBAction func pushAcknowList(_ sender: AnyObject) {
        let viewController = AcknowListViewController(fileNamed: "Pods-acknowledgements")
        viewController.headerText = "Visit: https://developer.apple.com"
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func pushAcknowListWithGroupedInsetStyle(_ sender: AnyObject) {
        if #available(iOS 13.0, *) {
            let viewController = AcknowListViewController(fileNamed: "Pods-acknowledgements", style: .insetGrouped)
            viewController.headerText = "Visit: https://developer.apple.com"
            navigationController?.pushViewController(viewController, animated: true)
        }
        return
    }

    @IBAction func pushAcknowListWithCustomTitle(_ sender: AnyObject) {
        if #available(iOS 13.0, *) {
            let viewController = AcknowListViewController(fileNamed: "Pods-acknowledgements", customTitle: "Custom Title")
            viewController.headerText = "Visit: https://developer.apple.com"
            navigationController?.pushViewController(viewController, animated: true)
        }
        return
    }
}
