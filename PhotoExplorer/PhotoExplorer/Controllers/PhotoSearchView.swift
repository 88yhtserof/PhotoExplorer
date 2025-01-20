//
//  PhotoSearchView.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/20/25.
//

import UIKit
import SnapKit

final class PhotoSearchView: ConfigurationView {
    
    let searchBar = UISearchBar()
    let sortButton = TitleToggleButton(selectedTitle: "관련순", unselecetedTitle: "최신순", image: "line.3.horizontal.circle")
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var delegate: PhotoSearchViewController?
    
    init(delegate: PhotoSearchViewController) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    //MARK: - Configuration
    override func configureView() {
        searchBar.delegate = delegate
        
        sortButton.isSelected = true
        sortButton.backgroundColor = .white
        
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.prefetchDataSource = delegate
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
    override func configureHierarchy() {
        addSubviews(searchBar, sortButton, collectionView)
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.trailing.equalToSuperview().inset(4)
        }
         
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
}
