//
//  Topic.swift
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
    
    public override init() {
        listOfQuestions = [Question]()
    }
    
    @objc
    var count: Int {
            return listOfQuestions.count
    }
    
    public override var debugDescription: String {
        return  "Questions: \(self.count)"
    }
}
