//
//  Word.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import Foundation

struct Word: Decodable {
    let category: String
    let level: Int
    
    let article: String
    let type: String
    
    let dutchWord: String
    let spanishWord: String

    let dutchVariants: String
    let spanishVariants: String
}
