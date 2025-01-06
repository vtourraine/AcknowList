//
//  ViewController.swift
//  AcknowExampleSPM
//
//  Created by Vincent Tourraine on 03/02/2021.
//

import UIKit
import SwiftUI
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

    @IBAction func presentPackageAcknowledgements(_ sender: UIButton) {
        guard let url = Bundle.main.url(forResource: "Package-version-1", withExtension: "resolved"),
              let data = try? Data(contentsOf: url),
              let acknowList = try? AcknowPackageDecoder().decode(from: data) else {
            return
        }

        let vc = AcknowListViewController()
        vc.acknowledgements = acknowList.acknowledgements
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func presentAcknowledgementsSwiftUI(_ sender: AnyObject) {
        // Load default acknowledgements from CocoaPods and Swift Package Manager
        let listViewController = AcknowListSwiftUIView()
        let viewController = UIHostingController(rootView: listViewController)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
}

