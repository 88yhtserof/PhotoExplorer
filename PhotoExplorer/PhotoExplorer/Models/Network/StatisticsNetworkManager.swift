//
//  StatisticsNetworkManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/20/25.
//

import Foundation
import Alamofire

class StatisticsNetworkManager: NetworkManager {
    static let shared = StatisticsNetworkManager()
    
    private override init() {}
    
    func getStatistics(for photoID: String, completion: @escaping (StatisticsResponse?, Error?) -> Void) {
        let urlComponents = StatisticsAPIConstructor().constructStatisticsURL(for: photoID)
        
        AF.request(urlComponents, method: .get, headers: [authorizationHeader])
            .responseDecodable(of: StatisticsResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("Success: Get statistics")
                    completion(value, nil)
                case .failure(let error):
                    print("ERROR: Get statistics", error, separator: "\n")
                }
            }
    }
    
}

struct StatisticsAPIConstructor {
    let scheme = NetworkAPIConstructor.scheme
    let host = NetworkAPIConstructor.host
    private let pathFormat = "/photos/%@/statistics"
    
    
    private func path(for photoID: String) -> String {
        return String(format: pathFormat, photoID)
    }
    
    func constructStatisticsURL(for photoID: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path(for: photoID)
        return components
    }
}
