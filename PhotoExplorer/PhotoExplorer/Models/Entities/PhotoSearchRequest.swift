//
//  PhotoSearchRequest.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/22/25.
//

import Foundation

struct PhotoSearchRequest: Request {
    let query: String
    let page: Int
    let order_by: String
    let color: String?
    
    var parameters: [String: Sendable] {
        var param: [String: Sendable] = [Query.query.name: query,
                                         Query.page.name: page,
                                         Query.order_by.name: order_by]
        if color != nil { param[Query.color.name] = color }
        return param
    }
    
    enum Query: String {
        case query
        case page
        case order_by
        case color
        
        var name: String {
            return rawValue
        }
    }
}
