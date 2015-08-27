//
//  AcknowListViewControllerTests.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 22/08/15.
//  Copyright © 2015 VTourraine. All rights reserved.
//

import UIKit
import XCTest

import AcknowList

class AcknowListViewControllerTests: XCTestCase {

    func testConfigureTableView() {
        let bundle = NSBundle(forClass: AcknowParserTests.self)
        let path = bundle.pathForResource("Pods-AcknowExampleTests-acknowledgements", ofType: "plist")
        let viewController = AcknowListViewController(acknowledgementsPlistPath: path)

        XCTAssertEqual(viewController.numberOfSectionsInTableView(viewController.tableView), 1)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 1)

        let cell = viewController.tableView(viewController.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertEqual(cell.textLabel?.text, "AcknowList")
    }
}
