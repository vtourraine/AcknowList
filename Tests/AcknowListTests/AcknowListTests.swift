//
//  AcknowListTests.swift
//  AcknowExampleTests
//
//  Created by Vincent Tourraine on 15/08/15.
//  Copyright © 2015-2025 Vincent Tourraine. All rights reserved.
//

import XCTest

@testable import AcknowList

class AcknowListTests: XCTestCase {

    func testPlusOperator() throws {
        let acknow1 = Acknow(title: "a1")
        let acknow2 = Acknow(title: "a2")
        let acknowList1 = AcknowList(headerText: "h1", acknowledgements: [acknow1], footerText: nil)
        let acknowList2 = AcknowList(headerText: nil, acknowledgements: [acknow2], footerText: "f2")

        let acknowList3 = acknowList1 + acknowList2
        XCTAssertEqual(acknowList3.headerText, "h1")
        XCTAssertEqual(acknowList3.footerText, "f2")
        XCTAssertEqual(acknowList3.acknowledgements.count, 2)
        let firstAcknow = try XCTUnwrap(acknowList3.acknowledgements.first)
        XCTAssertEqual(firstAcknow.title, "a1")
    }
}
