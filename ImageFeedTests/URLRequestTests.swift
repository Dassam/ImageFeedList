//
//  URLRequestTests.swift
//  ImageFeedTests
//
//  Created by Dassam on 22.08.2023.
//

import XCTest
@testable import ImageFeedList

final class URLRequestTests: XCTestCase {
    func testMakingRequest() {
        // given
        let path = "/me"
        let method = "GET"

        // when
        let request = URLRequest.makeHTTPRequest(path: path, httpMethod: method)!

        // then
        XCTAssertEqual(request.httpMethod, method)
        XCTAssertEqual(request.url!.path(), path)
    }
}
