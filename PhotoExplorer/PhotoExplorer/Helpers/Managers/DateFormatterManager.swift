//
//  DateFormatterManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}
    
    let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    let createdAtFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    func String(from dateStr: String, to dateFormat: DateFormat) -> String {
        let beforeDate = defaultFormatter.date(from: dateStr) ?? Date()
        
        switch dateFormat {
        case .createdAt:
            return createdAtFormatter.string(from: beforeDate)
        }
    }
    
    enum DateFormat {
        case createdAt
    }
}
