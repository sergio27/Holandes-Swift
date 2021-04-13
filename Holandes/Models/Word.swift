//
//  Word.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import Foundation

struct Word {
    var category: String
    
    var dutchWord : String
    var spanishWord: String
    
    var isHetWord: Bool
    
    init(category:String, dutch dutchWord:String, spanish spanishWord:String, hetWord: Bool) {
        self.category = category
        self.dutchWord = dutchWord
        self.spanishWord = spanishWord
        self.isHetWord = hetWord
    }
}
