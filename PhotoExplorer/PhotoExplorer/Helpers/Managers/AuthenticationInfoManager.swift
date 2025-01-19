//
//  AuthenticationInfoManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import Foundation

enum AuthenticationInfoManager {
    case unsplach
    
    private static let dictionary: NSDictionary? = {
        guard let url = Bundle.main.url(forResource: "authenticationInfo", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: url) else {
            print("Failed to find resource")
            return nil
        }
        return dictionary
    }()
    
    var clientID: String? {
        guard let dictionary = AuthenticationInfoManager.dictionary,
              let clientID = dictionary["Unsplash-client-id"] as? String else {
            print("Failed to case resource")
            return nil
        }
        return clientID
    }
}
