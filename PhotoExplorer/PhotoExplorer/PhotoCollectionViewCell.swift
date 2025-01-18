//
//  PhotoCollectionViewCell.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: ConfigurationCollectionViewCell, ListConfigurable {
    
    private var photoImageView = UIImageView()
    
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    
    override func configureContentView() {
        photoImageView.backgroundColor = .systemGray6
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(photoImageView)
    }
    
    override func configureConstraints() {
        let width = contentView.frame.width
        
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with value: Photo) {
        
    }
}
