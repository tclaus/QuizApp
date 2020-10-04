//
//  ScoreCalculationsUtilities.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 04.10.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import Foundation

class ScoreCalculationsUtilities : NSObject {

    /// Returns a value from 0 und 1 that reflects the percentage of correctly answered question
    @objc
    static func calculateCorrectPercent(questions : [Question]) -> Float {
        let correctCount = calculateNumberOfCorrectAnswers(questions: questions)
        return Float(correctCount) / Float(questions.count)
    }
    
    /// Returns the total score of all correctly answered questions
    @objc
    static func calculateCorrectScore(questions : [Question]) -> Int {
        var score = 0
        for question in questions {
            if question.hasBeenAnsweredCorrectly() {
                score += question.points ;
            }
        }
        return score
    }

    
    /// returns the number of correct answers in list of questions
    /// - Parameter questions: all answered questions
    @objc
    static func calculateNumberOfCorrectAnswers(questions : [Question]) -> Int {
        var correctCount = 0
        for question in questions {
            if question.hasBeenAnsweredCorrectly() {
                correctCount += 1
            }
        }
        return correctCount
    }
    
}
