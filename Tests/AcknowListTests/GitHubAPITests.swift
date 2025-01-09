//
//  GitHubAPITests.swift
//  AcknowExampleTests
//
//  Created by Vincent Tourraine on 07/12/2023.
//  Copyright © 2015-2025 Vincent Tourraine. All rights reserved.
//

import XCTest

@testable import AcknowList

class GitHubAPITests: XCTestCase {

    func testRecognizeGitHubRepository() {
        let repoURL = URL(string: "https://github.com/vtourraine/AcknowList.git")!
        XCTAssertTrue(GitHubAPI.isGitHubRepository(repoURL))

        let otherURL = URL(string: "https://www.website.com")!
        XCTAssertFalse(GitHubAPI.isGitHubRepository(otherURL))
    }

    func testGetLicenseRequest() {
        let repoURL = URL(string: "https://github.com/vtourraine/AcknowList.git")!
        let request = GitHubAPI.getLicenseRequest(for: repoURL)

        XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/repos/vtourraine/AcknowList/license")
        XCTAssertEqual(request.allHTTPHeaderFields, ["Accept": "application/vnd.github.raw", "X-GitHub-Api-Version": "2022-11-28"])
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
