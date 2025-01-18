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
