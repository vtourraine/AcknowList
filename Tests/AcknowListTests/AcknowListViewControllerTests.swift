//
//  AcknowListViewControllerTests.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 22/08/15.
//  Copyright © 2015-2025 Vincent Tourraine. All rights reserved.
//

import XCTest

@testable import AcknowList

#if !os(macOS)
class AcknowListViewControllerTests: XCTestCase {

    func testConfigureTableView() throws {
        let bundle = resourcesBundle()
        let plistFileURL = try XCTUnwrap(bundle.url(forResource: "Pods-acknowledgements", withExtension: "plist"))
        let viewController = AcknowListViewController(plistFileURL: plistFileURL)

        XCTAssertEqual(viewController.tableView.style, .grouped, "should use `.grouped` as the default table view style")

        XCTAssertEqual(viewController.numberOfSections(in: viewController.tableView), 1)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 3)

        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "AcknowList (1)")
    }

    #if os(iOS)
    @available (iOS 13.0, *)
    func testConfigureTableViewWithCustomStyle() throws {
        let bundle = resourcesBundle()
        let plistFileURL = try XCTUnwrap(bundle.url(forResource: "Pods-acknowledgements", withExtension: "plist"))
        let viewController = AcknowListViewController(plistFileURL: plistFileURL, style: .insetGrouped)

        XCTAssertEqual(viewController.tableView.style, .insetGrouped)
    }
    #endif

    func testSortsAcknowledgementsByTitle() throws {
        let bundle = resourcesBundle()
        let plistFileURL = try XCTUnwrap(bundle.url(forResource: "Pods-acknowledgements-multi", withExtension: "plist"))
        let viewController = AcknowListViewController(plistFileURL: plistFileURL)

        XCTAssertEqual(viewController.acknowledgements.count, 3)
        XCTAssertEqual(viewController.acknowledgements[0].title, "A title")
        XCTAssertEqual(viewController.acknowledgements[1].title, "B title")
        XCTAssertEqual(viewController.acknowledgements[2].title, "C title")
    }

    func testConfigureTableHeader() throws {
        let viewController = AcknowListViewController()
        viewController.headerText = "Test"

        viewController.viewDidLoad()
        viewController.viewWillAppear(true)

        let headerView = try XCTUnwrap(viewController.tableView.tableHeaderView)
        XCTAssertFalse(headerView.isUserInteractionEnabled)
        XCTAssertEqual(headerView.subviews.count, 1)

        let label = try XCTUnwrap(headerView.subviews.first as? UILabel)
        XCTAssertEqual(label.text, "Test")
        XCTAssertFalse(label.isUserInteractionEnabled)
        XCTAssertNil(label.gestureRecognizers)
    }

    func testConfigureTableHeaderWithLink() throws {
        let viewController = AcknowListViewController()
        viewController.headerText = "Test https://developer.apple.com"

        viewController.viewDidLoad()
        viewController.viewWillAppear(true)

        let headerView = try XCTUnwrap(viewController.tableView.tableHeaderView)
        XCTAssertTrue(headerView.isUserInteractionEnabled)
        XCTAssertEqual(headerView.subviews.count, 1)

        let label = try XCTUnwrap(headerView.subviews.first as? UILabel)
        XCTAssertEqual(label.text, "Test https://developer.apple.com")
        XCTAssertTrue(label.isUserInteractionEnabled)

        let gestureRecognizers = try XCTUnwrap(label.gestureRecognizers)
        XCTAssertEqual(gestureRecognizers.count, 1)
    }
}
#endif
