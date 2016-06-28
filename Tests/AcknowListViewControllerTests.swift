//
//  AcknowListViewControllerTests.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 22/08/15.
//  Copyright © 2015-2016 VTourraine. All rights reserved.
//

import UIKit
import XCTest

@testable import AcknowList

class AcknowListViewControllerTests: XCTestCase {

    func testConfigureTableView() {
        let bundle = Bundle(for: AcknowListViewControllerTests.self)
        let plistPath = bundle.pathForResource("Pods-acknowledgements", ofType: "plist")

        let viewController = AcknowListViewController(acknowledgementsPlistPath: plistPath)

        XCTAssertEqual(viewController.numberOfSections(in: viewController.tableView), 1)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 1)

        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "AcknowList")
    }

    func testSortsAcknowledgementsByTitle() {
        let bundle = Bundle(for: AcknowListViewControllerTests.self)
        let plistPath = bundle.pathForResource("Pods-acknowledgements-multi", ofType: "plist")

        let viewController = AcknowListViewController(acknowledgementsPlistPath: plistPath)
        XCTAssertEqual(viewController.acknowledgements?.count, 3)
        XCTAssertEqual(viewController.acknowledgements?[0].title, "A title")
        XCTAssertEqual(viewController.acknowledgements?[1].title, "B title")
        XCTAssertEqual(viewController.acknowledgements?[2].title, "C title")
    }
}
