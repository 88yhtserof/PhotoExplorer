//
//  InfoBlockView.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//

import UIKit
import SnapKit

final class InfoBlockView: ConfigurationView {
    
    private let titleLabel = UILabel()
    private lazy var horizontalStackView = UIStackView(arrangedSubviews: [titleLabel])
    
    var contentView: UIView? {
        didSet {
            if let contentView {
                horizontalStackView.addArrangedSubview(contentView)
            }
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
    }
    
    override func configureView() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.alignment = .top
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
