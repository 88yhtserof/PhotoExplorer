//
//  NetworkManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import Foundation
import Alamofire

// TODO: - 상태 코드 / 네트워크 단절
class NetworkManager {
    let authorizationHeader: HTTPHeader = {
        let value = "Client-ID " + (AuthenticationInfoManager.unsplach.clientID ?? "")
        let header = HTTPHeader(name: "Authorization", value: value)
        return header
    }()
}

enum NetworkAPIConstructor {
    static let scheme = "https"
    static let host = "api.unsplash.com"
}


enum UnsplashRequest {
    case search
    case statistics(String)
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
        return ["page": "1",
                "color": "white",
                "order_by": "relevant"]
    }
}
