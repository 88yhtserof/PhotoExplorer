//
//  BaseViewModel.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 2/10/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform()
}
