//
//  Question.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 12.02.18.
//  Copyright © 2018 Claus-Software. All rights reserved.
//

import UIKit

class Question: NSObject {
    
    @objc
    var questionID: Int
    @objc
    var level: Int
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
    var points : Float {
        get {
            return Float(self.level) * 100.0
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
    
    @objc
    init(dictionary: [String:Any]) {
        
        self.text = dictionary["text"] as! String
        self.explanation = dictionary["explanation"] as! String
        self.category = dictionary["category"] as! String
        
        self.level = ( dictionary["levelId"] as! NSNumber) as! Int
        self.questionID  = Int(dictionary["questionId"] as! String)!
        
        let answerArray = dictionary["answers"] as! [[String:Any]]
        for answerDictionary in answerArray {
            let answer = Answer(dictionary: answerDictionary)
            self.answers.append(answer)
        }
    }
    
    override var debugDescription: String {
        return "ID: \(questionID), Level: \(level), text: \(text)"
    }
}
