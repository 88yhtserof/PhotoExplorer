//
//  TitleToggleButton.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import UIKit

class TitleToggleButton: UIButton {
    
    lazy var selectedConfiguration = configureSelectedConfiguration(title: selectedTitle) {
        didSet {
            self.configuration = selectedConfiguration
        }
    }
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
        config.cornerStyle = .capsule
        return config
    }
    
    var selectedTitle: String {
        didSet {
            selectedConfiguration.title = selectedTitle
        }
    }
    var unselectedTitle: String {
        didSet {
            unselectedConfiguration.title = unselectedTitle
        }
    }
    var image: UIImage? {
        didSet {
            selectedConfiguration.image = image
            unselectedConfiguration.image = image
        }
    }
    var imageColor: UIColor? {
        didSet {
            selectedConfiguration.imageColorTransformer = UIConfigurationColorTransformer{ _ in self.imageColor ?? .black }
            unselectedConfiguration.imageColorTransformer = UIConfigurationColorTransformer{ _ in self.imageColor ?? .black }
        }
    }
    
    override var backgroundColor: UIColor? {
        set {
            selectedConfiguration.baseBackgroundColor = newValue
            unselectedConfiguration.baseBackgroundColor = newValue
        }
        get {
            return self.backgroundColor
        }
    }
    
    init(selectedTitle: String, unselecetedTitle: String? = nil, image: String? = nil) {
        self.selectedTitle = selectedTitle
        self.unselectedTitle = unselecetedTitle ?? selectedTitle
        if let image {
            self.image = UIImage(systemName: image)
        }
        super.init(frame: .zero)
        configuration = selectedConfiguration
    }
    
    convenience init() {
        self.init(selectedTitle: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSelected.toggle()
    }
}



