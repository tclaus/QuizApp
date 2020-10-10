//
//  ResultAggregate.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 04.10.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import Foundation

/// Represents game statistics , date of game and archived points
class ResultAggregate: NSObject, Codable {
    
    /// Date of game
    @objc
    var date: Date = Date.init()
    
    /// Points achived in this game
    @objc
    var points: Int = 0
    
    /// Percent of correct answers
    @objc
    var percent: Float = 0.0
    
}
