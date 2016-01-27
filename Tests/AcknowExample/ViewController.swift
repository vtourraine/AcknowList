//
//  ViewController.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 15/08/15.
//  Copyright (c) 2015-2016 VTourraine. All rights reserved.
//

import UIKit

import AcknowList

class ViewController: UIViewController {

    @IBAction func pushAcknowList(sender: AnyObject) {
        let path = NSBundle.mainBundle().pathForResource("Pods-AcknowExample-acknowledgements", ofType: "plist")
        let viewController = AcknowListViewController(acknowledgementsPlistPath: path)

        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
