//
//  UserDefaultsManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/23/25.
//

import Foundation

enum UserDefaultsManager {
    
    enum Key: String {
        case isOnboardingCompleted
        
        var key: String {
            return rawValue
        }
    }
    
    static var isOnboardingCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Key.isOnboardingCompleted.key)
        } set {
            UserDefaults.standard.set(newValue, forKey: Key.isOnboardingCompleted.key)
        }
    }
}
