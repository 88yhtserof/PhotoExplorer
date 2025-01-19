//
//  InfoView.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//


import UIKit
import SnapKit

final class InfoView: ConfigurationView {
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private lazy var horizontalStackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel])
    
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
    }
    
    override func configureView() {
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        contentLabel.font = .systemFont(ofSize: 14, weight: .regular)
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
    }
    
    override func configureHierarchy() {
        addSubviews(horizontalStackView)
    }
    
    override func configureConstraints() {
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
