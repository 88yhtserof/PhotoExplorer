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
        case userInfo
        
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
    
    static var userInfo: UserInfo? {
        get {
            guard let data = UserDefaults.standard.object(forKey: Key.userInfo.key) as? Data else { return nil }
            do {
                let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                return userInfo
            } catch {
                print("Error: failed to encode userInfo")
                return nil
            }
        } set {
            guard let newValue else {
                UserDefaults.standard.removeObject(forKey: Key.userInfo.key)
                print("Remove userInfo")
                return
            }
            do {
                let encoded = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey: Key.userInfo.key)
            } catch {
                print("Error: failed to encode userInfo")
                return
            }
        }
    }
    
    static var nickname: String? {
        get {
            UserDefaultsManager.userInfo?.nickname
        } set {
            guard let newValue else { return }
            print(newValue)
            var userInfo = UserDefaultsManager.userInfo ?? UserInfo(nickname: newValue)
            userInfo.nickname = newValue
            UserDefaultsManager.userInfo = userInfo
        }
    }
    
    static var birth: Date? {
        get {
            UserDefaultsManager.userInfo?.birth
        } set {
            guard let newValue else { return }
            var userInfo = UserDefaultsManager.userInfo ?? UserInfo(birth: newValue)
            userInfo.birth = newValue
            UserDefaultsManager.userInfo = userInfo
        }
    }
    
    static var level: Int? {
        get {
            UserDefaultsManager.userInfo?.level
        } set {
            guard let newValue else { return }
            var userInfo = UserDefaultsManager.userInfo ?? UserInfo(level: newValue)
            userInfo.level = newValue
            UserDefaultsManager.userInfo = userInfo
        }
    }
}


