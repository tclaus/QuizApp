//
//  TestQuestionsContainer.swift
//  DasQuizTests
//
//  Created by Thorsten Claus on 19.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import XCTest

class TestQuestionsContainer: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /**
     test Add one new question
     */
    func testAddNewQuestion() {
        
        let questions = Questions()
        
        let newServerQuestion = getNewQuestion()
        let results = questions.mergeNewQuestions(newQuestions: [newServerQuestion])
        
        XCTAssertTrue(results.added == 1)
        XCTAssertTrue(results.updated == 0)
        XCTAssertEqual(questions.count, 1)
        
        let newQuestion = questions.listOfQuestions.first
        XCTAssertEqual(newQuestion?.uid, newServerQuestion._id)
        XCTAssertEqual(newQuestion?.text, newServerQuestion.text)
        XCTAssertEqual(newQuestion?.category, newServerQuestion.category)
        XCTAssertEqual(newQuestion?.explanation, newServerQuestion.explanation)
        XCTAssertEqual(newQuestion?.level, newServerQuestion.level)
        // Todo: check answers
    }

    func testUpdateExistingQuestion() {
        let questions = Questions()
        
        let newServerQuestion = getNewQuestion()
        questions.mergeNewQuestions(newQuestions: [newServerQuestion])
        // Added one question
        
        // Now change a question
        newServerQuestion.text = "This question has been changed"
        let results = questions.mergeNewQuestions(newQuestions: [newServerQuestion])
        XCTAssertTrue(results.updated == 1)
        XCTAssertTrue(results.added == 0)
        
        let changedQuestion = questions.listOfQuestions.first
        XCTAssertEqual(changedQuestion?.text, "This question has been changed")
        
    }
    
    private func getNewQuestion() -> ServerQuestion {
        let serverQuestion = ServerQuestion()
        serverQuestion._id = "123_abc"
        serverQuestion.text = "This is a question"
        serverQuestion.category = "Demo-Category"
        serverQuestion.correctAnswer = "correct"
        serverQuestion.wrongAnswer1 = "Wrong 1"
        serverQuestion.wrongAnswer2 = "Wrong 2"
        serverQuestion.wrongAnswer3 = "Wrong 3"
        serverQuestion.explanation = "Exclamation"
        serverQuestion.language = "de"
        serverQuestion.level = 1
        return serverQuestion
    }

}
