//
//  Search.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//

import Foundation

enum Search {
    
    // Returns the word if validated, otherwise return nil.
    static func validateSearchWord(_ word: String) -> String? {
        let trimmedWord = word.trimmingCharacters(in: .whitespaces).lowercased()
        return trimmedWord.count < 2 ? nil : trimmedWord
    }
}
