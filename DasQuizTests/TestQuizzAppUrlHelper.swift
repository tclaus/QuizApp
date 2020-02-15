//
//  TestQuizzAppUrlHelper.swift
//  DasQuizTests
//
//  Created by Thorsten Claus on 16.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import XCTest

class TestQuizzAppUrlHelper: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAPIURLRequest() {
        
        let request = QuizzAppUrlHelper.getServiceURLRequest(apiPath: "/api", queryItems: nil)
        XCTAssertNotNil(request)
        let url = request.url
        XCTAssertNotNil(url)
        
        let components = URLComponents.init(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertTrue((components?.path.hasSuffix("/api"))!)
        
    }

    func testGetAPIURLRequestWithParameters() {
        
        let query = [URLQueryItem.init(name: "language", value: "de")]
        
        let request = QuizzAppUrlHelper.getServiceURLRequest(apiPath: "/api", queryItems: query)
        XCTAssertNotNil(request)
        let url = request.url
        XCTAssertNotNil(url)
        
        let components = URLComponents.init(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertTrue((components?.path.hasSuffix("/api"))!)
        
        XCTAssertEqual(components?.queryItems?.first!.name, "language")
        XCTAssertEqual(components?.queryItems?.first!.value, "de")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
