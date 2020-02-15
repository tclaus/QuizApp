//
//  QuestionsFileLoader.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 20.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import UIKit

@objc
class QuestionsFileLoader: NSObject {

   @objc
    static func loadQuestionsFromFile(fileName: String) -> Questions {
        
        // Needs Application host that copies the bundle files
        if let fullPath = Bundle.main.url(forResource: fileName, withExtension: nil) {
            
            if let jsonData = try? Data.init(contentsOf: fullPath) {
            
            let decoder = JSONDecoder()
            let questionsFromFile = try! decoder.decode([Question].self, from: jsonData)
            let questions = Questions()
            questions.listOfQuestions = questionsFromFile
            return questions
            }
        } else {
            print("Could not find questions file")
    }
        return Questions()
    }
        
    static func storeQuestionsToFile(fileName: String, questions: Questions) {
        if let fullPath = Bundle.main.url(forResource: fileName, withExtension: nil) {
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(questions.listOfQuestions) {
                writeToFile(data: jsonData, fileUrl: fullPath)
            }
        }
    }
    
    fileprivate static func writeToFile(data jsonData: Data, fileUrl: URL) {
        // Write to file
        do {
            try jsonData.write(to: fileUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
