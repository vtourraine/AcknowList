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
    
    var style: UITableView.Style = .grouped
    var headerTextShouldAppear: Bool = true
    var footerTextShouldAppear: Bool = true
    var headerText: String = "Visit: https://developer.apple.com"
    

    @IBAction func pushAcknowList(_ sender: AnyObject) {
        var viewController: AcknowListViewController
        if style == .grouped {
            viewController = AcknowListViewController(fileNamed: "Pods-acknowledgements")
        }
        else {
            viewController = AcknowListViewController(fileNamed: "Pods-acknowledgements", style: style)
            if style == .plain {
                viewController.tableView.backgroundColor = .groupTableViewBackground
            }
        }
        viewController.tableView.tableFooterView = UIView(frame: .zero)
        
        viewController.headerText = headerTextShouldAppear ? headerText : nil
        if footerTextShouldAppear == false {
            viewController.footerText = nil
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func presentAcknowList(_ sender: AnyObject) {
        let viewController = AcknowListViewController(fileNamed: "Pods-acknowledgements", style: style)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: viewController, action: #selector(AcknowListViewController.dismissViewController(_:)))
        viewController.navigationItem.leftBarButtonItem = item
        
        if style == .plain {
            viewController.tableView.backgroundColor = .groupTableViewBackground
        }
        viewController.tableView.tableFooterView = UIView(frame: .zero)

        viewController.headerText = headerTextShouldAppear ? headerText : nil
        if footerTextShouldAppear == false {
            viewController.footerText = nil
        }
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func styleValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            style = .grouped
            
        case 1:
            style = .plain
            
        case 2:
            if #available(iOS 13.0, *) {
                style = .insetGrouped
            } else {
                style = .grouped
            }
            
        default:
            break
        }
    }
    
    @IBAction func headerTextSwitchValueChanged(_ sender: UISwitch) {
        headerTextShouldAppear = sender.isOn
    }
    
    @IBAction func footerTextSwitchValueChanged(_ sender: UISwitch) {
        footerTextShouldAppear = sender.isOn
    }
}
