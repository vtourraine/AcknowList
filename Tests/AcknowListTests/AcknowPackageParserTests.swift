//
//  AcknowPackageParserTests.swift
//  AcknowExampleTests
//
//  Created by Vincent Tourraine on 15/08/15.
//  Copyright © 2015-2022 Vincent Tourraine. All rights reserved.
//

import XCTest

@testable import AcknowList

class AcknowPackageParserTests: XCTestCase {

    func testParsePackageVersion1() throws {
        let bundle = resourcesBundle()
        let path = try XCTUnwrap(bundle.path(forResource: "Package-version-1", ofType: "resolved"))
        let parser = try AcknowPackageParser(contentsOf: URL(fileURLWithPath: path))
        XCTAssertNotNil(parser)

        let acknowledgements = parser.parseAcknowledgements()
        XCTAssertEqual(acknowledgements.count, 6)
        
        let first = try XCTUnwrap(acknowledgements.first)
        XCTAssertEqual(first.title, "AcknowList")
        XCTAssertEqual(first.repository, URL(string: "https://github.com/vtourraine/AcknowList.git"))
        XCTAssertNil(first.text)
        XCTAssertNil(first.license)
    }

    func testParsePackageVersion2() throws {
        let bundle = resourcesBundle()
        let path = try XCTUnwrap(bundle.path(forResource: "Package-version-2", ofType: "resolved"))
        let parser = try AcknowPackageParser(contentsOf: URL(fileURLWithPath: path))
        XCTAssertNotNil(parser)

        let acknowledgements = parser.parseAcknowledgements()
        XCTAssertEqual(acknowledgements.count, 1)

        let first = try XCTUnwrap(acknowledgements.first)
        XCTAssertEqual(first.title, "thirdpartymailer")
        XCTAssertEqual(first.repository, URL(string: "https://github.com/vtourraine/ThirdPartyMailer.git"))
        XCTAssertNil(first.text)
        XCTAssertNil(first.license)
    }
}
