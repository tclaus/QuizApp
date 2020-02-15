//
//  LoadNewQuestionsTest.swift
//  DasQuizTests
//
//  Created by Thorsten Claus on 16.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import XCTest

/**
 Tests the loading and parsing new Questions
 */
class TestQuestionLoader: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadNewQuestions() {
        
        let expectation = XCTestExpectation(description: "Download questions")
        
        let questionLoader = QuestionLoader()
        questionLoader.loadNewQuestions(language: "de", since: "2020-01-01",questionCompletionHandler: {data in
            if data == nil {
                expectation.isInverted = true
            }
            expectation.fulfill()
        })
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLoadAndProcessNewQuestions() {
        
        let expectation = XCTestExpectation(description: "Download and Process new Questions")
        
        let existingQuestions = Questions() // create an empty question list - this list will be extended with new questions
        let questionLoader = QuestionLoader()
        
        UserDefaults.standard.removeObject(forKey: "last_check_for_new_questions_de")
        questionLoader.loadAndProcessNewQuestions(existingQuestions: existingQuestions,completed: {()-> Void in
            expectation.fulfill()
        })
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
        XCTAssertTrue(existingQuestions.count > 1) // Should have added one some entries
    }
    
}
