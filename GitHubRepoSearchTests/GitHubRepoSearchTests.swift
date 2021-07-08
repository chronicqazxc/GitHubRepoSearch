//
//  GitHubRepoSearchTests.swift
//  GitHubRepoSearchTests
//
//  Created by YuHan Hsiao on 2021/07/06.
//

import XCTest
@testable import GitHubRepoSearch

class GitHubRepoSearchTests: XCTestCase {
    var sut: GitHubSearch!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GitHubSearch(apiKey: "your_github_access_token")
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGitHubSearchRefresh() {
        let promise = expectation(description: "Value Received")
        
        sut.urlSession = stubUrlSession("MockSearchPage1")
        sut.keyword = "chronicqazxc"
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            XCTAssertEqual(self.sut.repos.count, 1)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    func testGitHubSearchGetMore() {
        let promise = expectation(description: "Value Received")

        sut.urlSession = stubUrlSession("MockSearchPage1")
        sut.keyword = "chronicqazxc"
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.sut.urlSession = self.stubUrlSession("MockSearchPage2")
            self.sut.getMore()
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                XCTAssertEqual(self.sut.repos.count, 2)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func stubUrlSession(_ file: String) -> URLSessionProtocol {
        let bundlePath = Bundle.main.path(forResource: file, ofType: "json")!
        let stubbedData = try! String(contentsOfFile: bundlePath).data(using: .utf8)!
        let urlString =
            "https://github.com"
        let url = URL(string: urlString)!
        let stubbedResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        return StubURLSession(data: stubbedData, response: stubbedResponse, error: nil)
    }
}
