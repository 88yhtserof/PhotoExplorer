//
//  SceneDelegate.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/17/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let rootViewController = ViewController()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

