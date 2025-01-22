//
//  ColorFilter.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/21/25.
//

import UIKit

struct ColorFilter {
    let title: String
    let color: Color
    
    enum Color: Int, CaseIterable {
        case black, white, yellow, red, purple, green, blue
        
        var title: String {
            switch self {
            case .black:
                return "black"
            case .white:
                return "white"
            case .yellow:
                return "yellow"
            case .red:
                return "red"
            case .purple:
                return "purple"
            case .green:
                return "green"
            case .blue:
                return "blue"
            }
        }
        
        var title_kr: String {
            switch self {
            case .black:
                return "검정"
            case .white:
                return "흰색"
            case .yellow:
                return "노랑"
            case .red:
                return "빨강"
            case .purple:
                return "보라"
            case .green:
                return "초록"
            case .blue:
                return "파랑"
            }
        }
        
        var color: UIColor {
            switch self {
            case .black:
                return .black
            case .white:
                return .white
            case .yellow:
                return .yellow
            case .red:
                return .red
            case .purple:
                return .purple
            case .green:
                return .green
            case .blue:
                return .blue
            }
        }
    }
}
