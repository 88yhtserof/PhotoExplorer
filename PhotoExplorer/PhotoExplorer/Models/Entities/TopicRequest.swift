//
//  TopicRequest.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/23/25.
//

import Foundation

struct TopicRequest: Request {
    let topicID: String
    let page: Int = 10
    
    var parameters: [String: Sendable] {
        return [Query.page.name: page]
    }
    
    enum Query: String {
        case page
        
        var name: String {
            return rawValue
        }
    }
}