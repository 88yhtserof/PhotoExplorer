//
//  UserInfo.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/23/25.
//

import Foundation

struct UserInfo: Codable {
    var nickname: String?
    var birth: Date?
    var level: Int?
    
    init(nickname: String? = nil, birth: Date? = nil, level: Int? = nil) {
        self.nickname = nickname
        self.birth = birth
        self.level = level
    }
}
