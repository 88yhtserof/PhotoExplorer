//
//  StatisticsResponse.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/20/25.
//

import Foundation

struct StatisticsResponse: Decodable {
    let downloads: Information
    let views: Information
}

struct Information: Decodable {
    let total: Int
}
