//
//  ActiveQuizGame.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 10.02.18.
//  Copyright © 2018 Claus-Software. All rights reserved.
//

import UIKit

/**
 Holds informatin about current Game
 */
class ActiveQuizGame: NSObject {
    
    @objc
    var questions: Questions?
    @objc
    var totalNumberOfQuestions: Int = 0
    @objc
    var currentIndex: Int = 0
}
