//
//  ViewController.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 15/08/15.
//  Copyright (c) 2015-2017 Vincent Tourraine. All rights reserved.
//

import UIKit

import AcknowList

class ViewController: UIViewController {

    @IBAction func pushAcknowList(_ sender: AnyObject) {
        let viewController = AcknowListViewController()

        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
