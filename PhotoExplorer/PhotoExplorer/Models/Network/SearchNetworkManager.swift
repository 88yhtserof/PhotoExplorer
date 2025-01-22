//
//  SearchNetworkManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import Foundation
import Alamofire

final class SearchNetworkManager: NetworkManager {
    static let shared = SearchNetworkManager()
    private let urlConstructor = SearchAPIContructor()
    
    private override init() {}
    
    func getSearchPhotos(_ keyword: String, page: Int, orderBy: SearchAPIContructor.OrderBy = .relevant, color: String? = nil, completionHandler: @escaping ((PhotoSearchResponse?, Error?) -> Void)) {
        guard let url = urlConstructor.constructSearchURL(keyword, page: page, orderBy: orderBy, color: color).url else {
            print("Failed to create url")
            return
        }
        let headers: HTTPHeaders = [ authorizationHeader ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: PhotoSearchResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("Success")
                    completionHandler(value, nil)
                case .failure(let error):
                    print("Error", error)
                    completionHandler(nil, error)
                }
            }
    }
}

struct SearchAPIContructor {
    let scheme = NetworkAPIConstructor.scheme
    let host = NetworkAPIConstructor.host
    let path = "/search/photos"
    
    private let perPageQueryItem = URLQueryItem(name: QueryName.per_page.name, value: String(20))
    
    func constructSearchURL(_ keyword: String, page: Int, orderBy: OrderBy, color: String?) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        var queryItems = [ URLQueryItem(name: QueryName.query.name, value: keyword),
                           URLQueryItem(name: QueryName.page.name, value: String(page)),
                           perPageQueryItem,
                           URLQueryItem(name: QueryName.order_by.name, value: orderBy.name) ]
        if let color {
            let queryItemColor = URLQueryItem(name: QueryName.color.name, value: color)
            queryItems.append(queryItemColor)
        }
        components.queryItems = queryItems
        return components
    }
    
    enum OrderBy: String {
        case relevant
        case latest
        
        var name: String {
            return rawValue
        }
    }
    
    enum QueryName: String {
        case query
        case page
        case per_page
        case order_by
        case color
        
        var name: String {
            return rawValue
        }
    }
    
}
