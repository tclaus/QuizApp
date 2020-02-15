//
//  ServerQuestion.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import UIKit

class ServerQuestion: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case explanation = "explanation"
        case text = "text"
        case correctAnswer = "correctAnswer"
        case wrongAnswer1 = "wrongAnswer1"
        case wrongAnswer2 = "wrongAnswer2"
        case wrongAnswer3 = "wrongAnswer3"
        case createDate = "createDate"
        case language = "language"
        case level = "level"
        case category = "category"
    }
    
    var _id = ""
    var explanation = ""
    var text = ""
    var correctAnswer = ""
    var wrongAnswer1 = ""
    var wrongAnswer2 = ""
    var wrongAnswer3 = ""
    var createDate = ""
    var language = ""
    var level = 0
    var category = ""
    
    init() {
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try (container.decodeIfPresent(String.self, forKey: ._id) ?? "")
        self.explanation = try (container.decodeIfPresent(String.self, forKey: .explanation) ?? "")
        self.text = try (container.decodeIfPresent(String.self, forKey: .text) ?? "")
        self.correctAnswer = try (container.decodeIfPresent(String.self, forKey: .correctAnswer) ?? "")
        self.wrongAnswer1 = try (container.decodeIfPresent(String.self, forKey: .wrongAnswer1) ?? "")
        self.wrongAnswer2 = try (container.decodeIfPresent(String.self, forKey: .wrongAnswer2) ?? "")
        self.wrongAnswer3 = try (container.decodeIfPresent(String.self, forKey: .wrongAnswer3) ?? "")
        self.createDate = try (container.decodeIfPresent(String.self, forKey: .createDate) ?? "")
        
        // Level value may i stored as invalid String type on server side
        if let level_ = try? (container.decodeIfPresent(Int.self, forKey: .level) ?? 0) {
            self.level = level_
        } else {
            // Try a string parsing if no decode was possible
            if let level_ = try? Int((container.decodeIfPresent(String.self, forKey: .level) ?? "0"))! {
                self.level = level_
            }
        }
        
        self.category = try (container.decodeIfPresent(String.self, forKey: .category) ?? "")
        self.language = try (container.decodeIfPresent(String.self, forKey: .language) ?? "")
    }
    
    func isValid() -> Bool {
        if (_id == ""){ return false}
        if (text == "") { return false }
        if (correctAnswer == "") { return false }
        if (wrongAnswer1 == "") { return false }
        if (wrongAnswer2 == "") { return false }
        if (wrongAnswer3 == "") { return false }
        if (language == "") { return false }
        if (category == "") { return false }
        if (level == 0) { return false }
        
        // explanation field can be empty
        return true
    }
    
}
