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

    @objc
    func sendReport(questionID : Int, reason : Int)  {
        print("Sending a report...Question: \(questionID), Reason:\(reason)")
        
        let JSONData = ["reason":reason,
                        "questionID":questionID]
        
        let configuration = URLSessionConfiguration.default
        
        var request = QuizzAppUrlHelper.getServiceURLRequest(apiPath: "reports", queryItems: nil)
        request.httpMethod = "POST";
        request.timeoutInterval = 30;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody  = try! JSONSerialization.data( withJSONObject: JSONData, options: [])
        

        let session = URLSession(configuration: configuration)
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
