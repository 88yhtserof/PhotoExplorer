//
//  ScrollView.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/21/25.
//
import UIKit
import SnapKit

class ScrollView: UIScrollView {
    
    enum Direction {
        case vertical
        case hotizontal
    }
    
    let scrollDirection: Direction
    
    let contentView = UIView()
    
    init(_ scrollDirection: Direction = .vertical) {
        self.scrollDirection = scrollDirection
        super.init(frame: .zero)
        
        configureHierarchy()
        configureConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubviews(contentView)
    }
    
    func configureConstraints() {
        contentView.snp.makeConstraints { make in
            switch scrollDirection {
            case .hotizontal:
                make.height.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
            case .vertical:
                make.width.equalToSuperview()
                make.verticalEdges.equalToSuperview()
            }
        }
    }
}
