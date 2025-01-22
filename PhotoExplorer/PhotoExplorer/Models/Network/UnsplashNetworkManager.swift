//
//  UnsplashNetworkManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import Foundation
import Alamofire

final class UnsplashNetworkManager {
    static let shared = UnsplashNetworkManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(api: UnsplashRequest,
                                   type: T.Type,
                                   completionHandler: @escaping ((T) -> Void),
                                   failureHandler: @escaping ((Error) -> Void)) {
        guard let url = api.endpoint else {
            print("Failed to create url")
            return
        }
        
        AF.request(url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.headers)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                failureHandler(error)
            }
        }
    }
}
