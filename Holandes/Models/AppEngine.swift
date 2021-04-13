//
//  AppModel.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import Foundation

class AppEngine {
    
    let words: [Word]
    
    init() {
        words = [
            Word(category: "Dieren", dutch:"hond", spanish: "perro", hetWord: false),
            Word(category: "Dieren", dutch:"kat", spanish: "gato", hetWord: false),
            Word(category: "Dieren", dutch:"konijn", spanish: "conejo", hetWord: true),
            Word(category: "Dieren", dutch:"schaap", spanish: "oveja", hetWord: true),
            Word(category: "Dieren", dutch:"olifant", spanish: "elefante", hetWord: false)
        ]
    }
    
}
