//
//  AcknowViewControllerTests.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 22/08/15.
//  Copyright © 2015-2016 VTourraine. All rights reserved.
//

import UIKit
import XCTest

@testable import AcknowList

class AcknowViewControllerTests: XCTestCase {

    func testLoadView() {
        let acknow = Acknow(title: "Title", text: "Text...")
        let viewController = AcknowViewController(acknowledgement: acknow)
        viewController.loadView()

        XCTAssertEqual(viewController.title, "Title")
        XCTAssertEqual(viewController.textView!.text, "Text...")
    }
}
