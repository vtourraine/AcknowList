//
//  ViewController.swift
//  AcknowExampleCocoaPods
//
//  Created by Vincent Tourraine on 03/02/2021.
//

import UIKit
import SwiftUI
import AcknowList

class ViewController: UIViewController {

    @IBAction func presentAcknowledgements(_ sender: UIButton) {
        let vc = AcknowListViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func presentAcknowledgementsSwiftUI(_ sender: UIButton) {
        guard let path = Bundle.main.path(forResource: "Pods-AcknowExampleCocoaPods-acknowledgements", ofType: "plist") else {
            return
        }

        let viewController = UIHostingController(rootView: NavigationView { AcknowListSwiftUIView(plistPath: path) })
        present(viewController, animated: true)
    }
}

