//
//  ConfigurationCollectionViewCell.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import UIKit

/// A collection view cell that provides configuration methods and calls those methods at an appropriate times.
class ConfigurationCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
        configureHierarchy()
        configureConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContentView(){}
    
    func configureHierarchy() {}
    
    func configureConstraints() {}
}
