//
//  TopicsNetworkManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/20/25.
//

import Foundation
import Alamofire

class TopicsNetworkManager: NetworkManager {
    static let shared = TopicsNetworkManager()
    private let urlConstructor = TopicsAPIConstructor()
    
    private override init() {}
    
    func getTopicPhotos(for topicID: String, completion: @escaping ([Photo]?, Error?) -> Void) {
        guard let url = urlConstructor.constructTopicPhotosURL(for: topicID).url else {
            print("Failed to create url")
            return
        }
        let headers: HTTPHeaders = [ authorizationHeader ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: PhotoResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("Success: Get topic photos")
                    completion(value, nil)
                case .failure(let error):
                    print("ERROR: Get statistics", error, separator: "\n")
                }
            }
    }
}

struct TopicsAPIConstructor {
    let scheme = NetworkAPIConstructor.scheme
    let host = NetworkAPIConstructor.host
    private let pathFormat = "/topics/%@/photos"
    private let pageQueryItem = URLQueryItem(name: "page", value: String(10))
    
    private func path(for topicID: String) -> String {
        return String(format: pathFormat, topicID)
    }
    
    func constructTopicPhotosURL(for topicID: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path(for: topicID)
        components.queryItems = [pageQueryItem]
        
        return components
    }
}
