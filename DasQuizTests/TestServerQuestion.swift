//
//  ServerQuestionTest.swift
//  DasQuizTests
//
//  Created by Thorsten Claus on 17.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import XCTest

class TestServerQuestions: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDecodeValidJSONQuestion() {
        let validQuestion = """
        {
        "_id": "59732c1f500175bae6016295",
        "text": "Der Zwergplanet Pluto wurde im Jahr 2015 von welcher Raumsonde besucht?",
        "correctAnswer": "New Horizons",
        "wrongAnswer1": "BepiColombo",
        "wrongAnswer2": "Juno",
        "wrongAnswer3": "Cassini",
        "explanation" : "https://google.de",
        "level": 6,
        "category": "Gesellschaft",
        "createDate": "2017-07-14T06:58:28.490Z",
        "language":"de" }
        """
        
        let jsonData = validQuestion.data(using: .utf8)!
        let question = try! JSONDecoder().decode(ServerQuestion.self, from: jsonData)
        XCTAssertNotNil(question)
        
        XCTAssertEqual(question._id,"59732c1f500175bae6016295" )
        XCTAssertEqual(question.text, "Der Zwergplanet Pluto wurde im Jahr 2015 von welcher Raumsonde besucht?")
        XCTAssertEqual(question.correctAnswer, "New Horizons")
        XCTAssertEqual(question.wrongAnswer1, "BepiColombo")
        XCTAssertEqual(question.wrongAnswer2, "Juno")
        XCTAssertEqual(question.wrongAnswer3, "Cassini")
        XCTAssertEqual(question.explanation, "https://google.de")
        XCTAssertEqual(question.level, 6)
        XCTAssertEqual(question.createDate, "2017-07-14T06:58:28.490Z")
        XCTAssertEqual(question.language, "de")
    }
    
    
    func testDecodeMissingExplanationQuestion() {
        // Questionwithout Explanation field should be valid
        
        let validQuestion = """
           {
           "_id": "59732c1f500175bae6016295",
           "text": "Der Zwergplanet Pluto wurde im Jahr 2015 von welcher Raumsonde besucht?",
           "correctAnswer": "New Horizons",
           "wrongAnswer1": "BepiColombo",
           "wrongAnswer2": "Juno",
           "wrongAnswer3": "Cassini",
           "level": 6,
           "category": "Gesellschaft",
           "createDate": "2017-07-14T06:58:28.490Z",
           "language":"de" }
           """
        
        let jsonData = validQuestion.data(using: .utf8)!
        let question = try! JSONDecoder().decode(ServerQuestion.self, from: jsonData)
        XCTAssertNotNil(question)
        XCTAssertTrue(question.isValid())
        XCTAssertEqual(question._id,"59732c1f500175bae6016295" )
        XCTAssertEqual(question.text, "Der Zwergplanet Pluto wurde im Jahr 2015 von welcher Raumsonde besucht?")
        XCTAssertEqual(question.correctAnswer, "New Horizons")
        XCTAssertEqual(question.wrongAnswer1, "BepiColombo")
        XCTAssertEqual(question.wrongAnswer2, "Juno")
        XCTAssertEqual(question.wrongAnswer3, "Cassini")
        XCTAssertEqual(question.level, 6)
        XCTAssertEqual(question.createDate, "2017-07-14T06:58:28.490Z")
        XCTAssertEqual(question.language, "de")
    }
    
    func testDecodeLevelIsString() {
        // In currupt Data the Level field might be a JSON String
        // Should be parsed as in field
           let validQuestion = """
           {
           "_id": "59732c1f500175bae6016295",
           "text": "Der Zwergplanet Pluto wurde im Jahr 2015 von welcher Raumsonde besucht?",
           "correctAnswer": "New Horizons",
           "wrongAnswer1": "BepiColombo",
           "wrongAnswer2": "Juno",
           "wrongAnswer3": "Cassini",
           "explanation" : "https://google.de",
           "level": "6",
           "category": "Gesellschaft",
           "createDate": "2017-07-14T06:58:28.490Z",
           "language":"de" }
           """
           
           let jsonData = validQuestion.data(using: .utf8)!
           let question = try! JSONDecoder().decode(ServerQuestion.self, from: jsonData)
           XCTAssertNotNil(question)
           XCTAssertTrue(question.isValid())
           XCTAssertEqual(question._id,"59732c1f500175bae6016295" )
           XCTAssertEqual(question.text, "Der Zwergplanet Pluto wurde im Jahr 2015 von welcher Raumsonde besucht?")
           XCTAssertEqual(question.correctAnswer, "New Horizons")
           XCTAssertEqual(question.wrongAnswer1, "BepiColombo")
           XCTAssertEqual(question.wrongAnswer2, "Juno")
           XCTAssertEqual(question.wrongAnswer3, "Cassini")
           XCTAssertEqual(question.explanation, "https://google.de")
           XCTAssertEqual(question.level, 6) // This was as String in JSON
           XCTAssertEqual(question.createDate, "2017-07-14T06:58:28.490Z")
           XCTAssertEqual(question.language, "de")
       }
    
    func testDecodeMissingFields() {
        // Explanation is missing
        
        let validQuestion = """
        {
         }
        """
        // Should return a (invalid) question
        
        let jsonData = validQuestion.data(using: .utf8)!
        let question = try! JSONDecoder().decode(ServerQuestion.self, from: jsonData)
        XCTAssertNotNil(question)
        XCTAssertFalse(question.isValid())
    }
    
}
