//
//  TestQuestionsFileLoader.swift
//  DasQuizTests
//
//  Created by Thorsten Claus on 20.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import XCTest

class TestQuestionsFileLoader: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testLoadQuestionsFromFile() {
        let questions = QuestionsFileLoader.loadQuestionsFromFile(fileName: "1000-questions_de.json")
        XCTAssertTrue(questions.count > 1)
    }
    
    func testStoreQuestionFile() {
        
        let questions = Questions()
        let question = Question()
        
        question.uid = "123_abc"
        question.text = "Question"
        question.category = "Category"
        question.explanation = "explanation"
        question.level = 1
        
        var answer = Answer()
        answer.text = "This is correct answer"
        answer.correct = true
        question.answers.append(answer)
        
        answer = Answer()
        answer.text = "This is wrong answer1"
        answer.correct = false
        question.answers.append(answer)
        
        answer = Answer()
        answer.text = "This is wrong answer2"
        answer.correct = false
        question.answers.append(answer)
        
        answer = Answer()
        answer.text = "This is wrong answer3"
        answer.correct = false
        question.answers.append(answer)
        questions.listOfQuestions = [question]
        
        QuestionsFileLoader.storeQuestionsToFile(fileName: "1000-questions_de.json", questions: questions)
        let loadedQuestions = QuestionsFileLoader.loadQuestionsFromFile(fileName: "1000-questions_de.json")
        
        XCTAssert(loadedQuestions.count == 1)
        let firstQuestion = loadedQuestions.listOfQuestions.first
        
        XCTAssertEqual(firstQuestion?.uid, question.uid)
        XCTAssertEqual(firstQuestion?.text, question.text)
        XCTAssertEqual(firstQuestion?.category, question.category)
        XCTAssertEqual(firstQuestion?.level, question.level)
        XCTAssertEqual(firstQuestion?.explanation, question.explanation)
        // TODO: test answers
    }
    
}
