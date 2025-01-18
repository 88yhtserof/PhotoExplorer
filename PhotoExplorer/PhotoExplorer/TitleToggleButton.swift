//
//  TitleToggleButton.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import UIKit

class TitleToggleButton: UIButton {
    
    lazy var selectedConfiguration = configureSelectedConfiguration(title: selectedTitle)
    lazy var unselectedConfiguration = configureSelectedConfiguration(title: unselectedTitle)
    
    override var isSelected: Bool {
        didSet {
            configuration = isSelected ? selectedConfiguration : unselectedConfiguration
        }
    }
    
    private func configureSelectedConfiguration(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        return config
    }
    
    let selectedTitle: String
    let unselectedTitle: String
    let image: UIImage?
    
    init(selectedTitle: String, unselecetedTitle: String, image: String) {
        self.selectedTitle = selectedTitle
        self.unselectedTitle = unselecetedTitle
        self.image = UIImage(systemName: image)
        super.init(frame: .zero)
        configuration = selectedConfiguration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
