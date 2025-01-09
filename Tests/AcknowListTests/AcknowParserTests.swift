//
//  AcknowParserTests.swift
//  AcknowExampleTests
//
//  Created by Vincent Tourraine on 15/08/15.
//  Copyright © 2015-2025 Vincent Tourraine. All rights reserved.
//

import XCTest

@testable import AcknowList

class AcknowParserTests: XCTestCase {

    func testFindLink() throws {
        let url = try XCTUnwrap(AcknowParser.firstLink(in: "test cocoapods.org"))
        XCTAssertEqual(url, URL(string: "http://cocoapods.org"))
    }

    func testFindNoLink() {
        let url = AcknowParser.firstLink(in: "test")
        XCTAssertNil(url)
    }
}
