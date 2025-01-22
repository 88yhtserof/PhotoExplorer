//
//  UnsplashRequest.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/22/25.
//

import Foundation
import Alamofire

enum UnsplashRequest {
    case search(PhotoSearchRequest)
    case statistics(photoID: String)
    case topic(String)
    
    static let authorizationValue = AuthenticationInfoManager.unsplach.clientID
    
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var endpoint: URL? {
        var path: String
        switch self {
        case .search:
            path = "search/photos"
        case .statistics(let photoID):
            path = "/photos/\(photoID)/statistics"
        case .topic(let topicID):
            path = "/topics/\(topicID)/photos"
        }
        return URL(string: baseURL + path)
    }
    
    var headers: HTTPHeaders {
        return [ "Authorization": "Client-ID \(UnsplashRequest.authorizationValue ?? "")" ]
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .search, .statistics, .topic:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .search(let query):
            return query.parameters
        case .statistics(let photoID):
            return [:]
        case .topic(let string):
            return [:]
        }
    }
}

