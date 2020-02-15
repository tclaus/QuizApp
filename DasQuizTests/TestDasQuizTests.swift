//
//  DasQuizTests.swift
//  DasQuizTests
//
//  Created by Thorsten Claus on 15.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import XCTest

class TestDasQuiz: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLevelBoundaries() {
        let gameStats = GameStats.INSTANCE
        gameStats.currentLevel = 0
        XCTAssertEqual(1, gameStats.currentLevel)
        gameStats.currentLevel = 11
        XCTAssertEqual(10, gameStats.currentLevel)
    }
    
    func testLevelUp() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let gameStats = GameStats.INSTANCE
        gameStats.currentLevel = 0;
        XCTAssertEqual(1, gameStats.currentLevel)
        let result = gameStats.levelUp();
        XCTAssertTrue(result);
        XCTAssertEqual(2, gameStats.currentLevel)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
