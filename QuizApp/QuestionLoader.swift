//
//  NewServerQuestions.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import UIKit

/**
 Load new questions from server and adds it to existing set of questions
 */
class QuestionLoader: NSObject {
    
    /// Loads new questions from server and adds them to the existing questions list
    func loadAndProcessNewQuestions(existingQuestions : Questions, completed: @escaping (Int, Int) -> () ) {
        // as a parameters - insert the current question list
        // make a server-call
        // add to questions list
        var language =  UserDefaults.standard.string(forKey: "question_language")
        if language == nil {
            language = "de"
            UserDefaults.standard.set(language, forKey: "question_language")
        }
        
        var lastCheck =  UserDefaults.standard.string(forKey: "last_check_for_new_questions_" + language!)
        
        if lastCheck == nil {
            lastCheck = "2017-01-01"
        }
        
        // check once a week
        #if targetEnvironment(simulator)
            lastCheck = "2017-01-01"
        #endif
        if (daysSinceLastCheck(lastCheck: lastCheck!) > 1) {
            
            loadNewQuestions(language: language!, since: lastCheck!, questionCompletionHandler: { (jsonData) in
                var results : (added: Int,updated: Int) = (0,0)
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    let incommingNewQuestions = try! decoder.decode([ServerQuestion].self, from: jsonData)
                    results = existingQuestions.mergeNewQuestions(newQuestions: incommingNewQuestions)
                    print("Questions added: \(results.added), updated: \(results.updated)")
                    
                    let ts = self.currentTimeStamp()
                    UserDefaults.standard.set(ts, forKey: "last_check_for_new_questions_" + language!)
                }
                completed(results.added, results.updated)
            })
        }
    }
    
    func currentTimeStamp() -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        let dateString = dfmatter.string(from: Date())
        return dateString
    }
    
    func daysSinceLastCheck(lastCheck: String) -> Int {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        let lastCheckDate = dfmatter.date(from: lastCheck)!
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: lastCheckDate)
        let date2 = calendar.startOfDay(for: Date())
        let flags = Set([Calendar.Component.day])
        let dateComponents = calendar.dateComponents(flags, from: date1, to: date2)
        print("Last cheeck was: \(dateComponents)")
        return dateComponents.day!
    }
    
    /**
     Starts a Server Request to load new Questions
     */
    func loadNewQuestions(language: String,  since: String, questionCompletionHandler: @escaping  (Data?) -> Void ) {
        let getQuestions = "/api/questions"
        let query = [URLQueryItem.init(name: "language", value: language),URLQueryItem.init(name: "since", value: since) ]
        let request = QuizzAppUrlHelper.getServiceURLRequest(apiPath: getQuestions, queryItems: query)
        
        print("Load questions from server since: /(since)")
        
        let task = URLSession.shared.dataTask(with: request , completionHandler: { data, response, error in
            if let error = error {
                print("server-Error loading question: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error in response loading question: \(String(describing: error))")
                    return
            }
            if let content_type = httpResponse.allHeaderFields["Content-Type"] as? String, content_type.elementsEqual("application/json; charset=utf-8"),
                let data = data
            {
                // data should contain the json string
                DispatchQueue.main.async {
                    questionCompletionHandler(data)
                }
            }
        })
        task.resume()
    }
}
