//
//  ListConfigurable.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import Foundation

protocol ListConfigurable: AnyObject {
    associatedtype CellValue
    
    func configure(with value: CellValue)
}
