//
//  ViewController.swift
//  AcknowExampleCocoaPods
//
//  Created by Vincent Tourraine on 03/02/2021.
//

import UIKit
import AcknowList

class ViewController: UIViewController {

    @IBAction func presentAcknowledgements(_ sender: UIButton) {
        let vc = AcknowListViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
}

