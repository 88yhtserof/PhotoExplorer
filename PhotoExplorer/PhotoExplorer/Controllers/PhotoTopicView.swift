//
//  PhotoTopicView.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/20/25.
//

import UIKit

class PhotoTopicView: ConfigurationView {
    
    weak var delegate: PhotoTopicViewController?
    
    enum Section: Int, CaseIterable {
        case goldenHour
        case business
        case interior
        
        var query: String {
            switch self {
            case .goldenHour:
                return "golden-hour"
            case .business:
                return "business-work"
            case .interior:
                return "architecture-interior"
            }
        }
        
        var title: String {
            switch self {
            case .goldenHour:
                return "골든 아워"
            case .business:
                return "비즈니스 및 업무"
            case .interior:
                return "건축 및 인테리어"
            }
        }
    }
    
    //MARK: - Views
    let scrollView = UIScrollView()
    let contentView = UIView()
    let firstCollectionViewTitleLabel = UILabel()
    let secondCollectionViewTitleLabel = UILabel()
    let thirdCollectionViewTitleLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    lazy var secondCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    lazy var thirdCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    //MARK: - Initializer
    init(delegate: PhotoTopicViewController) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    //MARK: - Configuration
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        layout.itemSize = CGSize(width: 150, height: 200)
        return layout
    }
    
    override func configureView() {
        firstCollectionViewTitleLabel.text = Section.goldenHour.title
        firstCollectionViewTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        secondCollectionViewTitleLabel.text = Section.business.title
        secondCollectionViewTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        thirdCollectionViewTitleLabel.text = Section.interior.title
        thirdCollectionViewTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.tag = 0
        collectionView.showsHorizontalScrollIndicator = false
        
        secondCollectionView.delegate = delegate
        secondCollectionView.dataSource = delegate
        secondCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        secondCollectionView.tag = 1
        secondCollectionView.showsHorizontalScrollIndicator = false
        
        thirdCollectionView.delegate = delegate
        thirdCollectionView.dataSource = delegate
        thirdCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        thirdCollectionView.tag = 2
        thirdCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func configureHierarchy() {
        addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(firstCollectionViewTitleLabel, collectionView, secondCollectionViewTitleLabel, secondCollectionView, thirdCollectionViewTitleLabel, thirdCollectionView)
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.verticalEdges.equalToSuperview()
        }
        
        firstCollectionViewTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(15)
        }
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(firstCollectionViewTitleLabel.snp.bottom).offset(5)
        }
        
        secondCollectionViewTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(collectionView.snp.bottom).offset(20)
        }
        
        secondCollectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(secondCollectionViewTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        
        thirdCollectionViewTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(secondCollectionView.snp.bottom).offset(20)
        }
        
        thirdCollectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(thirdCollectionViewTitleLabel.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
