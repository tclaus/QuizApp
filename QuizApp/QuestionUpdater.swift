//
//  QuestionUpdater.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 21.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import UIKit

@objc
class QuestionUpdater: NSObject {

    let questionLoader = QuestionLoader()
    
    // Finally start update and produce a local message !
 
    @objc
    func updateQuestions(questions: Questions ) {
        questionLoader.loadAndProcessNewQuestions(existingQuestions: questions) { (added, updated) in
            
            // Notify only with new or updated questions!
            if (added == 0 && updated == 0) {
                print("No new questions, no updated questions found")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("New questions arrived", comment: "")
            content.body = String.init(format: NSLocalizedString("We got %lu new questions and %lu updated.", comment: ""), added,updated)
            
            let uuidString = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: nil)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
               }
            }
            
        }
    }
}
