//
//  PhotoSearchResponse.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import Foundation

struct PhotoSearchResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}

struct Photo: Decodable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let likes: Int
    let urls: PhotoURLs
}

struct PhotoURLs: Decodable {
    let raw: String
    let small: String
}
