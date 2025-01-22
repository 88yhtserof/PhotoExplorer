//
//  PhotoCollectionViewCell.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoCollectionViewCell: ConfigurationCollectionViewCell, ListConfigurable {
    
    private var photoImageView = UIImageView()
    private var starButton = UIButton()
    private var starButtonConfiguration = UIButton.Configuration.filled()
    
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    private lazy var width: CGFloat = contentView.frame.width
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = UIImage(systemName: "photo")
    }
    
    override func configureContentView() {
        photoImageView.backgroundColor = .systemGray6
        contentView.backgroundColor = .red
        
        starButtonConfiguration.baseBackgroundColor = .black.withAlphaComponent(0.2)
        starButtonConfiguration.image = UIImage(systemName: "star.fill")
        starButtonConfiguration.imageColorTransformer = UIConfigurationColorTransformer{ _ in .systemYellow }
        starButtonConfiguration.baseForegroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(photoImageView, starButton)
    }
    
    override func configureConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        starButton.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(8)
        }
    }
    
    func configure(with value: Photo) {
        
        starButtonConfiguration.title = value.likes.decimal()
        starButton.configuration = starButtonConfiguration
        
        let height = (CGFloat(value.height) * width) / CGFloat(value.width)
        let size = CGSize(width: width, height: height)
        let url = URL(string: value.urls.raw)
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: url,
                                   options: [.processor(DownsamplingImageProcessor(size: size)), .transition(.fade(1.2))])
    }
}
