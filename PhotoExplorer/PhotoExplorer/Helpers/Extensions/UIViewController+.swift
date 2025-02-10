//
//  UIViewController+.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/23/25.
//

import UIKit

extension UIViewController {
    
    func showOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    /// Switches the rootViewController of current window.
    func switchRootViewController(rootViewController: UIViewController, isNavigationEmbeded: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        if isNavigationEmbeded {
            window.rootViewController = UINavigationController(rootViewController: rootViewController)
        } else {
            window.rootViewController = rootViewController
        }
        window.makeKeyAndVisible()
    }
}
