//
//  Answer.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 05.02.18.
//  Copyright © 2018 Claus-Software. All rights reserved.
//

import Foundation

class Answer: NSObject {
    @objc
    var text: String = ""
    @objc
    var correct: Bool = false
    @objc
    var chosen: Bool = false
    
    @objc
    init(dictionary:[String:Any]) {
        self.text = dictionary["text"] as! String
        
        if let correct = dictionary["correct"] {
            self.correct = (correct as! NSNumber).intValue == 1 ? true : false
        }
        
        if let chosen = dictionary["chosen"] {
            self.chosen = (chosen as! NSNumber).intValue == 1 ? true : false
        }
    }
    
}
