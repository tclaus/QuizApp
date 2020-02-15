//
//  Answer.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 05.02.18.
//  Copyright © 2018 Claus-Software. All rights reserved.
//

import Foundation

@objc
class Answer: NSObject, Decodable, Encodable {
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case correct = "correct"
    }
    
    @objc
    var text: String = ""
    @objc
    var correct: Bool = false
    @objc
    var chosen: Bool = false
    
    override init() {
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try! (container.decodeIfPresent(String.self, forKey: CodingKeys.text) ?? "")
        self.correct = try! (container.decodeIfPresent(Bool.self, forKey: CodingKeys.correct) ?? false)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.text, forKey: CodingKeys.text)
        try container.encode(self.correct, forKey: CodingKeys.correct)
    }
    
    override var debugDescription: String {
        return "\(correct): \(text)"
       }
    
}
