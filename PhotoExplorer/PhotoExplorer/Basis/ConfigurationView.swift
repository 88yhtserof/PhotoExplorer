//
//  ConfigurationView.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//

import UIKit

/// A view cell that provides configuration methods and calls those methods at an appropriate times.
class ConfigurationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureHierarchy()
        configureConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){}
    
    func configureHierarchy() {}
    
    func configureConstraints() {}
}
