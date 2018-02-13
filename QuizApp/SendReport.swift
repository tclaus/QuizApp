//
//  SendReport.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 14.11.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import UIKit

/**
 Sends a report about a question
 */
class SendReport: NSObject {

    let baseURL : String = "https://rocky-temple-21345.herokuapp.com/"
    // let baseURL : String = "http://localhost:5000"
    
    @objc
    func sendReport(questionID : Int, reason : Int)  {
        print("Sending a report...Question: \(questionID), Reason:\(reason)")
        
        let JSONData = ["reason":reason,
                        "questionID":questionID]
        
        
        
        let configuration = URLSessionConfiguration.default
        
        let username = "quiz"
        let password = "lehn170#Yong"
        let authStr = "\(username):\(password)"
        
        let authData = authStr.data(using: String.Encoding.ascii)
        let authStrData : String = (authData?.base64EncodedString(options: []))!
        
        
        let session = URLSession(configuration: configuration)
        
        let request = NSMutableURLRequest()
        request.url = URL(string: baseURL)?.appendingPathComponent("reports")
        request.httpMethod = "POST";
        request.timeoutInterval = 30;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody  = try! JSONSerialization.data( withJSONObject: JSONData, options: [])
        request.setValue("Basic \(authStrData)", forHTTPHeaderField: "Authorization")

        
        let dataTask = session.dataTask(with: request as URLRequest) {data, response , error in
            //
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("No valid response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                
                
                if response == "SUCCESS"
                {
                    
                }
                
            default:
                print("Sending report got response \(httpResponse.statusCode)")
            }
        }
        dataTask.resume();
        
        
        
    }
    
}
