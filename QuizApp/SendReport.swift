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
        
        var request = QuizzAppUrlHelper.getServiceURLRequest(apiPath: "/reports", queryItems: nil)
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
            case 200,201:
                let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                print("SUCCESS: Send report to server: \(String(describing: response)) ")
                self.createReportSentNotification()
                
            default:
                print("Sending report got response \(httpResponse.statusCode)")
            }
        }
        dataTask.resume();
    }
    
    /**
     Send a positive message send notification
     */
    func createReportSentNotification(){
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Report sucessfully received", comment: "")
        content.body = NSLocalizedString("Thank you for sending a report", comment: "")
        
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
