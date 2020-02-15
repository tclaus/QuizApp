//
//  Questions.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 01.02.18.
//  Copyright © 2018 Claus-Software. All rights reserved.
//

import Foundation
import UIKit


/*
 Contains all available Questions for one specific language
 */
public class Questions: NSObject {
    
    @objc
    var listOfQuestions: [Question]
    
    func appendQuestion( question: Question) {
        listOfQuestions.append(question)
    }
    
    public override init() {
        listOfQuestions = [Question]()
    }
    
    @objc
    var count: Int {
        return listOfQuestions.count
    }
    
    /// Merge new questions to list of existing questions
    func mergeNewQuestions(newQuestions : [ServerQuestion] ) -> (added: Int,updated: Int)  {
        
        // copy dumb list to a hashed list and change existing questions
        //
        var addedQuestionCount : Int = 0
        var updatedQuestionCount : Int = 0
        
        var existingQuestionsHash = [String:Question]()
        for question in listOfQuestions {
            if (question.uid != "") {
                existingQuestionsHash[question.uid] = question
            }
        }
        
        // Merge existing questions or add new or unknown questions to list
        for newQuestion in newQuestions {
            if newQuestion.isValid() {
                if existingQuestionsHash[newQuestion._id] != nil {
                    updateExistingQuestion(existingQuestionsHash[newQuestion._id]!, newQuestion)
                    updatedQuestionCount += 1
                } else {
                    // Add loaded ServerQuestion as new App-Question
                    let newCreatedQuestion = Question()
                    updateExistingQuestion(newCreatedQuestion, newQuestion)
                    listOfQuestions.append(newCreatedQuestion)
                    addedQuestionCount += 1
                }
            }
        }
        return (addedQuestionCount, updatedQuestionCount)
    }
    
    private func updateExistingQuestion(_ existingQuestion : Question,_ newQuestion: ServerQuestion) {
        existingQuestion.uid = newQuestion._id
        existingQuestion.category = newQuestion.category
        existingQuestion.explanation = newQuestion.explanation
        existingQuestion.level = newQuestion.level
        existingQuestion.text = newQuestion.text
        
        let correctAnswer = Answer()
        correctAnswer.text = newQuestion.correctAnswer
        correctAnswer.correct = true
        existingQuestion.answers.append(correctAnswer)
        
        let wrongAnswer1 = Answer()
        wrongAnswer1.text = newQuestion.wrongAnswer1
        wrongAnswer1.correct = true
        existingQuestion.answers.append(wrongAnswer1)
        
        let wrongAnswer2 = Answer()
        wrongAnswer2.text = newQuestion.wrongAnswer2
        wrongAnswer2.correct = true
        existingQuestion.answers.append(wrongAnswer2)
        
        let wrongAnswer3 = Answer()
        wrongAnswer3.text = newQuestion.wrongAnswer3
        wrongAnswer3.correct = true
        existingQuestion.answers.append(wrongAnswer3)
    }
    
    
    public override var debugDescription: String {
        return  "Questions: \(self.count)"
    }
}
