//
//  DataSource.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 04.10.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import Foundation

class DataSource : NSObject {
    private static let timeBasedResulsFilename = "timebasedResultsAggregate.plist"
    private static let trainingResultsFilename = "trainingResultsAggregate.plist"
    
    
    @objc
    static func getLastPoints() -> Int {
       let results = loadAggregates(filename: timeBasedResulsFilename)
        if results.count > 0 {
            if let points = results.last?.points {
                return points
            }
        }
        return 0
    }
    
    /// Loads all results for time based games
    @objc
    static func loadTimeBasedAggregates() -> [ResultAggregate] {
        return loadAggregates(filename: timeBasedResulsFilename)
    }
    
    /// Adds a new result for time based games
    @objc
    static func saveTimeBasedAggregates(questions: [Question], dateOfGame : Date) {
        saveAggregates(filename: timeBasedResulsFilename, questions: questions, dateOfGame: dateOfGame)
    }
    
    @objc
    static func loadTrainingAggregates() -> [ResultAggregate] {
        return loadAggregates(filename: trainingResultsFilename)
    }
    
    @objc
    static func saveTrainingAggregates(questions: [Question], dateOfGame : Date) {
        saveAggregates(filename: trainingResultsFilename, questions: questions, dateOfGame: dateOfGame)
    }
    
    /// Returns the path to store results file
    static private func documentsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    
    static private func loadAggregates(filename: String)-> [ResultAggregate] {
        
        let path = documentsPath()
        let resultsStoragePath = URL(fileURLWithPath: path).appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: resultsStoragePath)
            let decoder = JSONDecoder()
            let resultAggregates = try decoder.decode([ResultAggregate].self, from: data)
            return resultAggregates
            
        } catch {
            print("Error occured while reading result aggregates: \(error)")
            return [ResultAggregate]()
        }
    }
    
    static private func saveAggregates(filename: String, questions: [Question], dateOfGame: Date) {
        
        let correctScore = ScoreCalculationsUtilities.calculateCorrectScore(questions: questions)
        let percent = ScoreCalculationsUtilities.calculateCorrectPercent(questions: questions)
        
        let newResult = ResultAggregate()
        newResult.date = dateOfGame
        newResult.points =  correctScore
        newResult.percent = Float(percent * 100).rounded()
        
        var existingResults :[ResultAggregate] = loadAggregates(filename: filename)
        existingResults.append(newResult)
        do {
            let path = documentsPath()
            let resultsStoragePath = URL(fileURLWithPath: path).appendingPathComponent(filename)
            let encoder = JSONEncoder()
            let data = try encoder.encode(existingResults)
            try data.write(to: resultsStoragePath)
            print("Saved game result")
        }
        catch {
            print("Could not save game results. Error: \(error)")
            return
        }
    }
    
}
