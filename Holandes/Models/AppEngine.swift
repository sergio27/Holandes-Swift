//
//  AppModel.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import Foundation

class AppEngine {
    
    static let engine = AppEngine()
    
    var allWords: [Word] = []
    var categories: [String: [Word]] = [ : ]
    
    var gameScores: [String: Int] = [:]
    
    var selectedOption = ""
    var selectedCategory = ""
    
    var words: [Word] = []
    
    var correctAnswers = 0
    var totalWords = 0
    var gameOver = false
    
    var results = ""
    
    func downloadWords() {
        if let url = Bundle.main.url(forResource: "DB", withExtension: "json") {
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
    
    func updateWords() {
        if let url = URL(string: K.URLs.WordsURL) {
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
            allWords = decodedWords
            loadCategories()
        }
        catch {
            print(error)
        }
    }
    
    func loadCategories() {
        categories.removeAll()
        
        allWords.forEach { word in
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
        
        allWords.forEach() { word in
            if word.type == option { selectedWords.append(word) }
        }
        
        return selectedWords.prefix(20).shuffled()
    }
    
    func loadNewGame(withCategory category: String) {
        selectedCategory = category
        
        if let selectedWords = categories[category] {
            words = selectedWords
            words.shuffle()
            
            totalWords = words.count
            print(totalWords)
        }
        
        correctAnswers = 0
        gameOver = false
    }
    
    func getNextWord() -> Word? {
        if(words.count == 0) {
            gameOver = true
            
            let score = Double(correctAnswers) / Double(totalWords) * 100
            saveScore(category: selectedCategory, score: Int(score))
            
            results = "Tuviste \(correctAnswers) de \(totalWords) respuestas correctas."
            return nil
        }
        
        let nextWord = words.popLast()
        return nextWord
    }
    
    func checkAnswer(forWord word: Word, answer: String) -> Bool{

        let formattedBase = formatWord(word: word.spanishWord)
        let formattedAnswer = formatWord(word: answer)
        
        var result = (formattedBase == formattedAnswer)
        
        if(!result) {
            let variants = word.spanishVariants.split(separator: ",")
            variants.forEach { variant in
                let trimmed = variant.trimmingCharacters(in: .whitespacesAndNewlines)
                if(trimmed == answer) {
                    result = true
                }
            }
        }
        
        if(result) {
            correctAnswers += 1
        }
        
        return result
    }
    
    func formatWord(word: String) -> String {
        var formattedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedWord = formattedWord.folding(options: .diacriticInsensitive, locale:nil)
        
        return formattedWord
    }
}
