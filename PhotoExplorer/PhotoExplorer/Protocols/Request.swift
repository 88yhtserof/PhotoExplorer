//
//  Request.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/22/25.
//

import Foundation

protocol Request {
    var parameters: [String: Sendable] { get }
}
