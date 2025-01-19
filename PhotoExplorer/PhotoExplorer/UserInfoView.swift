//
//  UserInfoView.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//

import UIKit
import SnapKit
import Kingfisher

final class UserInfoView: ConfigurationView {
    
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let createdAtLabel = UILabel()
    private lazy var verticalStackView = UIStackView(arrangedSubviews: [profileNameLabel, createdAtLabel])
    private lazy var horizontalStackView = UIStackView(arrangedSubviews: [profileImageView, verticalStackView])
    
    var imageURL: URL? {
        didSet{
            profileImageView.kf.setImage(with: imageURL)
        }
    }
    
    var name: String? {
        didSet {
            profileNameLabel.text = name
        }
    }
    
    var createdAt: String? {
        didSet {
            createdAtLabel.text = createdAt
        }
    }
    
    override func configureView() {
        let width: CGFloat = 50
        profileImageView.cornerRadius(width / 2)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .gray
        profileImageView.tintColor = .white
        
        profileNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        createdAtLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 2
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 4
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        
    }
    
    override func configureHierarchy() {
        addSubviews(horizontalStackView)
    }
    
    override func configureConstraints() {
        let width: CGFloat = 50
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(width)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
