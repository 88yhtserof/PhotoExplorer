//
//  EmptyCollectionViewCell.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import UIKit
import SnapKit

class EmptyCollectionViewCell: ConfigurationCollectionViewCell, ListConfigurable {
    private let descriptionLabel = UILabel()
    
    static let identifier = String(describing: EmptyCollectionViewCell.self)
    
    override func configureContentView() {
        descriptionLabel.numberOfLines = 1
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.textAlignment = .center
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(descriptionLabel)
    }
    
    override func configureConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with value: String) {
        descriptionLabel.text = value
    }
}
