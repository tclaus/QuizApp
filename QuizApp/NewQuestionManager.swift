//
//  NewQuestionManager.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.11.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import Foundation
import UIKit

class NewQuestionManager {
    
    let username = "quiz"
    let password = "lehn170#Yong"
    let baseURL : String = "https://rocky-temple-21345.herokuapp.com/"
    
    var text : String!
    var correctAnswer : String!
    var wrongAnswer1: String!
    var wrongAnswer2: String!
    var wrongAnswer3: String!
    var explanation: String!
    
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
        
        let JSONData : [String : Any] =  ["text":text,
                        "correctAnswer":correctAnswer,
                        "wrongAnswer1" : wrongAnswer1,
                        "wrongAnswer2" : wrongAnswer2,
                        "wrongAnswer3" : wrongAnswer3,
                        "explanation": explanation,
                        "level": level,
                        "language":language,
                        "category":category]
        
        
        
        let configuration = URLSessionConfiguration.default
        
        let authStr = "\(username):\(password)"
        
        let authData = authStr.data(using: String.Encoding.ascii)
        let authStrData : String = (authData?.base64EncodedString(options: []))!
        
        
        let session = URLSession(configuration: configuration)
        
        let request = NSMutableURLRequest()
        request.url = URL(string: baseURL)?.appendingPathComponent("newQuestions")
        request.httpMethod = "POST";
        request.timeoutInterval = 30;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody  = try! JSONSerialization.data( withJSONObject: JSONData, options: [])
        request.setValue("Basic \(authStrData)", forHTTPHeaderField: "Authorization")
        
        
        let dataTask = session.dataTask(with: request as URLRequest) {data, response , error in
            //
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("No valid response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200,201:
                
                let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                
                    print("SUCCESS: New question successfully end to server: \(response) ")
                
            default:
                print("Sending report got response \(httpResponse.statusCode)")
            }
            // Notify caller
            completionHandler(error)
            
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dataTask.resume();
        
        
        
    }

    
    
}


