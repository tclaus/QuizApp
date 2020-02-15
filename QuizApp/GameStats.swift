//
//  GameStats.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import UIKit

class GameStats: NSObject {
    
    let maxNumberOfTries = 3
    let maxLevel = 10
    private let gamestatFilename = "gameStats.plist"
    private var currentLevel_: Int = 1;
    
    @objc
    static let INSTANCE = GameStats()
    
    /// Number of succesfulk tries. After 3 level up and start from 0
    @objc
    var numberOfSuccessfulTries: Int = 0
    
    /// Current Level - starts from 1 to 10
    @objc
    var currentLevel: Int {
        set(value) {
            if value > 0 {
                if value > maxLevel {
                    currentLevel_ = maxLevel
                } else {
                    currentLevel_ = value
                }
            } else {
                currentLevel_ = 1
            }
            numberOfSuccessfulTries = 0;
        }
        get {
            return currentLevel_
        }
    }
    
    /// Points of last match
    @objc
    var lastPoints: Int = 0
    
    private override init() {
        super.init()
        self.loadData()
    }
    
    /// Updates to next level
    @objc
    public func levelUp() -> Bool {
        if numberOfSuccessfulTries >= numberOfTriesToNextLevel(level: currentLevel) {
            if currentLevel < maxLevel {
                currentLevel+=1
                numberOfSuccessfulTries = 0
                saveData()
                return true
            }
        } else {
            numberOfSuccessfulTries+=1
        }
        saveData()
        return false;
    }
    
    @objc
    public func levelDown() -> Bool {
        if numberOfSuccessfulTries == 0 {
            if currentLevel > 1 {
                currentLevel-=1
                numberOfSuccessfulTries = numberOfTriesToNextLevel(level: currentLevel)
                saveData()
                return true
            }
        } else {
            numberOfSuccessfulTries-=1
        }
        saveData()
        return false;
    }
    
    /// A try is an eqivalent of one played game. Higher levels need more succesful games before level uo
    private func numberOfTriesToNextLevel(level: Int) -> Int {
        switch level {
        case 1:
            return 0
        case 2:
            return 1;
        case 3:
            return 3;
        default:
            return maxNumberOfTries
        }
    }
    
    /// Saves current points
    @objc
    func saveData() {
        
        let path = URL(fileURLWithPath: documentsPath()).appendingPathComponent(gamestatFilename + ".plist")
        var dictionary = [String:Any]()
        dictionary["currentLevel"] = currentLevel
        dictionary["numberOfSuccessfulTries"] = numberOfSuccessfulTries
        dictionary["lastPoints"] = lastPoints
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .binary, options: 0)
            try data.write(to: path)
        } catch (let err){
            print(err.localizedDescription)
        }
        
    }
    
    /// Loads current Data
    func loadData() {
        if let path = Bundle.main.path(forResource: gamestatFilename, ofType: "plist") {
            let dictionary = NSDictionary(contentsOfFile: path) as! Dictionary<String, AnyObject>
            currentLevel = dictionary["currentLevel"] as! Int
            numberOfSuccessfulTries = dictionary["numberOfSuccessfulTries"] as! Int
            lastPoints = dictionary["lastPoints"] as! Int
            
        }
    }
    
    func documentsPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        return paths.firstObject as! String
    }
    
}
