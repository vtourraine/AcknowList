//
//  AcknowListTestsHelpers.swift
//  AcknowExample
//
//  Created by Vincent Tourraine on 04/12/
//  Copyright © 2015-2025 Vincent Tourraine. All rights reserved.
//

import XCTest

extension XCTestCase {

    func resourcesBundle() -> Bundle {
        let bundle = Bundle(for: AcknowParserTests.self)

        let spmTestBundlePath = bundle.bundlePath.appending("/../AcknowList_AcknowListTests.bundle")
        if let spmTestBundle = Bundle(path: spmTestBundlePath) {
            return spmTestBundle
        }
        else {
            return bundle
        }
    }
}
