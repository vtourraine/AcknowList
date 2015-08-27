//
//  AcknowViewControllerTests.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 22/08/15.
//  Copyright © 2015 VTourraine. All rights reserved.
//

import UIKit
import XCTest

import AcknowList

class AcknowViewControllerTests: XCTestCase {

    func testLoadView() {
        let acknow = Acknow(title: "Title", text: "Text...")
        let viewController = AcknowViewController(acknowledgement: acknow)
        viewController.loadView()

        XCTAssertEqual(viewController.title, "Title")
        XCTAssertEqual(viewController.textView!.text, "Text...")
    }
}
