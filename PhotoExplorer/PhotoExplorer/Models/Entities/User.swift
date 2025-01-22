//
//  User.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//

import Foundation

struct User: Decodable {
    let name: String
    let profile_image: UserURLs
}

struct UserURLs: Decodable {
    let small: String
}
