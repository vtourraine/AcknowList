//
//  AcknowListViewControllerTests.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 22/08/15.
//  Copyright © 2015-2019 Vincent Tourraine. All rights reserved.
//

import UIKit
import XCTest

@testable import AcknowList

class AcknowListViewControllerTests: XCTestCase {

    func testConfigureTableView() {
        let bundle = Bundle(for: AcknowListViewControllerTests.self)
        let plistPath = bundle.path(forResource: "Pods-acknowledgements", ofType: "plist")

        let viewController = AcknowListViewController(acknowledgementsPlistPath: plistPath)

        XCTAssertEqual(viewController.numberOfSections(in: viewController.tableView), 1)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 1)

        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "AcknowList")
    }

    func testSortsAcknowledgementsByTitle() {
        let bundle = Bundle(for: AcknowListViewControllerTests.self)
        let plistPath = bundle.path(forResource: "Pods-acknowledgements-multi", ofType: "plist")

        let viewController = AcknowListViewController(acknowledgementsPlistPath: plistPath)
        XCTAssertEqual(viewController.acknowledgements?.count, 3)
        XCTAssertEqual(viewController.acknowledgements?[0].title, "A title")
        XCTAssertEqual(viewController.acknowledgements?[1].title, "B title")
        XCTAssertEqual(viewController.acknowledgements?[2].title, "C title")
    }

    func testLoadFromMultiplePlist() {
        let bundle = Bundle(for: AcknowListViewControllerTests.self)
        let plistPath1 = bundle.path(forResource: "Pods-acknowledgements", ofType: "plist")
        let plistPath2 = bundle.path(forResource: "Pods-acknowledgements-multi", ofType: "plist")

        if let plistPath1 = plistPath1, let plistPath2 = plistPath2 {
            let viewController = AcknowListViewController(acknowledgementsPlistPaths: [plistPath1, plistPath2])
            XCTAssertEqual(viewController.acknowledgements?.count, 4)
            XCTAssertEqual(viewController.acknowledgements?[0].title, "A title")
            XCTAssertEqual(viewController.acknowledgements?[1].title, "AcknowList")
            XCTAssertEqual(viewController.acknowledgements?[2].title, "B title")
            XCTAssertEqual(viewController.acknowledgements?[3].title, "C title")
        }
        else {
            XCTFail()
        }
    }
}
