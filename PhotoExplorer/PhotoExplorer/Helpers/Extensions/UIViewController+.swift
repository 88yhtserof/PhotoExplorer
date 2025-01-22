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
}
