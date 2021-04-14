//
//  AppModel.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import Foundation

class AppEngine {
    
    static let engine = AppEngine()
    
    var words: [Word] = []
    var categories: [String: [Word]] = [ : ]
    
    var gameScores: [String: Int] = [:]
    
    var selectedOption = ""
    var selectedCategory = ""
    
    let wordsURL = "http://sergio27.com/holandes/words.txt"
    
    func downloadWords() {
        if let url = URL(string: wordsURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(data: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedWords: [Word] = try decoder.decode([Word].self, from: data)
            words = decodedWords
            loadCategories()
        }
        catch {
            print(error)
        }
    }
    
    func loadCategories() {
        words.forEach { word in
            let category = "\(word.category) (\(word.level))"
            
            if(categories[category] == nil) {
                categories[category] = []
            }
            
            categories[category]!.append(word)
            
        }
        
        updateCategories()
    }
    
    func updateCategories() {
        let userDefaults = UserDefaults.standard
        gameScores = [String : Int]()
        
        if let savedCategories = userDefaults.dictionary(forKey: "Game Scores") {
            categories.keys.forEach { category in
                if(savedCategories[category] == nil) {
                    gameScores[category] = 0
                }
                else {
                    gameScores[category] = savedCategories[category] as? Int
                }
            }
        }
        else {
            categories.keys.forEach { category in
                gameScores[category] = 0
            }
        }
        
        userDefaults.setValue(gameScores, forKey: "Game Scores")
    }
    
    func saveScore(category: String, score: Int) {
        
        if let oldScore = gameScores[category] {
            if(oldScore >= score) { return }
        }
        
        gameScores[category] = score
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(gameScores, forKey: "Game Scores")
        
    }
    
    func getWords(withCategory category: String) -> [Word] {
        if let selectedWords = categories[category] {
            return selectedWords
        }
        
        return []
    }
    
    func getWords(withOption option: String) -> [Word] {
        var selectedWords: [Word] = []
        
        words.forEach() { word in
            if word.type == option { selectedWords.append(word) }
        }
        
        return selectedWords
    }
}
