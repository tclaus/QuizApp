//
//  Question.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 12.02.18.
//  Copyright © 2018 Claus-Software. All rights reserved.
//

import UIKit

class Question: NSObject, Decodable, Encodable {
    
    enum CodingKeys: String, CodingKey {
        case uid = "_id"
        case questionId = "questionId"
        case text = "text"
        case levelId = "levelId"
        case explanation = "explanation"
        case category = "category"
        case answers = "answers"
    }
    
    @objc
    var uid : String = ""
    @objc
    var questionID: Int = 0
    @objc
    var level: Int = 0
    @objc
    var text: String = ""
    @objc
    var answers = [Answer]()
    @objc
    var explanation: String = ""
    @objc
    var category: String = ""
    
    
    /**
     Number of points given for a correct answered question
     */
    @objc
    var points : Int {
        get {
            return level * 100
        }
    }
    
    @objc
    func hasBeenAnsweredCorrectly() -> Bool {
        for answer in self.answers {
            if(answer.correct && answer.chosen) {
                return true
            }
        }
        return false
    }
    
    /**
     On Answered questions check if answerIndex is the correct Answer
     */
    @objc
    func indexIsCorrectAnswer(answerIndex: Int) -> Bool {
        if answerIndex < self.answers.count {
            let answer = self.answers[answerIndex]
            return answer.correct
        }
        return false
    }
    
    @objc
    func indexIsChosenAnswer(answerIndex: Int) -> Bool {
        if answerIndex < self.answers.count {
            let answer = self.answers[answerIndex]
            return answer.chosen
        }
        return false
    }
    
    @objc
    override func isEqual(_ object: Any?) -> Bool {
        if let o = object as? Question {
            return o.questionID == self.questionID
        }
        return false
    }
    
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.uid = try (container.decodeIfPresent(String.self, forKey: CodingKeys.uid) ?? "")
        if let questionId = try? (container.decodeIfPresent(String.self, forKey: CodingKeys.questionId) ?? "0") {
            self.questionID = Int(questionId)!
        }
        else {
            if let questionId = try? (container.decodeIfPresent(Int.self, forKey: CodingKeys.questionId) ?? 0) {
                self.questionID = questionId
            }
        }
        
        self.level = try (container.decodeIfPresent(Int.self, forKey: CodingKeys.levelId) ?? 0)
        self.text = try (container.decodeIfPresent(String.self, forKey: CodingKeys.text) ?? "")
        self.explanation = try (container.decodeIfPresent(String.self, forKey: CodingKeys.explanation) ?? "")
        self.category = try (container.decodeIfPresent(String.self, forKey: CodingKeys.category) ?? "")
        self.answers = try (container.decodeIfPresent([Answer].self, forKey: CodingKeys.answers) ?? [Answer]())
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uid, forKey: CodingKeys.uid)
        try container.encode(self.text, forKey: CodingKeys.text)
        try container.encode(self.level, forKey: CodingKeys.levelId)
        try container.encode(self.explanation, forKey: CodingKeys.explanation)
        try container.encode(self.category, forKey: CodingKeys.category)
        try container.encode(self.answers, forKey: CodingKeys.answers)
    }
    
    override var debugDescription: String {
        return "ID: \(questionID), Level: \(level), text: \(text)"
    }
}
