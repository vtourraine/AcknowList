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
        vc.acknowledgements = [Acknow(title: "T1", text: "abc"),
                               Acknow(title: "T2", text: "abc"),
                               Acknow(title: "T3", text: "abc")]
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
}

