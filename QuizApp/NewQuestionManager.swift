//
//  NewQuestionManager.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.11.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import Foundation
import UIKit


/// Loads new questions from web service
class NewQuestionManager {
    
    var text : String = ""
    var correctAnswer : String = ""
    var wrongAnswer1: String = ""
    var wrongAnswer2: String = ""
    var wrongAnswer3: String = ""
    var explanation: String = ""
    
    var language : String! {
        get {
            let pre = NSLocale.preferredLanguages[0]
            return pre
        }
    }
    var level : Int = 0
    var category : String!
    
    func send( completionHandler: @escaping (Error?) -> Swift.Void)   {
        print("Sending a new question...")
        
        let JSONData : [String : Any] =  [
            "text": text as Any,
            "correctAnswer": correctAnswer as Any,
            "wrongAnswer1" : wrongAnswer1 as Any,
            "wrongAnswer2" : wrongAnswer2 as Any,
            "wrongAnswer3" : wrongAnswer3 as Any,
            "explanation": explanation as Any,
            "level": level,
            "language":language!,
            "category":category!]
        
        var request = QuizzAppUrlHelper.getServiceURLRequest(apiPath: "/api/newQuestions", queryItems: nil)
        request.httpMethod = "POST";
        request.timeoutInterval = 30;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody  = try! JSONSerialization.data( withJSONObject: JSONData, options: [])
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let dataTask = session.dataTask(with: request as URLRequest) {data, response , error in
            
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("No valid response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200,201:
                let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                print("SUCCESS: New question successfully end to server: \(String(describing: response)) ")
                self.createSuccessNotification()
                
            default:
                print("Sending report got response \(httpResponse.statusCode)")
            }
            // Notify caller
            completionHandler(error)
            
        }
        dataTask.resume();
    }
    
    /**
        Send a positive message send notification
        */
       func createSuccessNotification(){
           let content = UNMutableNotificationContent()
           content.title = NSLocalizedString("New question received", comment: "")
           content.body = NSLocalizedString("Your question will be processed and added later to the database. Thank you.", comment: "")
           
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
