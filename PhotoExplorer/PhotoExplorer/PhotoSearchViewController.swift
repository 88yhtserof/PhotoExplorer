//
//  PhotoSearchViewController.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/17/25.
//

import UIKit

import SnapKit

final class PhotoSearchViewController: ConfigurationViewController {
    
    enum EmptyKind: String {
        case beforeSearch = "사진을 검색하세요"
        case noSearchResult = "검색 결과가 없습니다"
        
        var description: String {
            return rawValue
        }
    }
    
    enum Section: CaseIterable {
        static var allCases: [PhotoSearchViewController.Section] = [.empty(.beforeSearch), .empty(.noSearchResult), .photos]
        
        case empty(EmptyKind)
        case photos
        
        init?(_ section: Int) {
            switch section {
            case 0:
                self = .empty(.beforeSearch)
            case 1:
                self = .empty(.noSearchResult)
            case 2:
                self = .photos
            default:
                return nil
            }
        }
    }
    
    let searchBar = UISearchBar()
    let sortButton = TitleToggleButton(selectedTitle: "관련순", unselecetedTitle: "최신순", image: "line.3.horizontal.circle")
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let emptyCellIdentifier = EmptyCollectionViewCell.identifier
    private let photoCellIdentifier = PhotoCollectionViewCell.identifier
    
    let networkManager = SearchNetworkManager.shared
    var photos: [Photo] = []
    let totalPage: Int = 1
    let currentPage: Int = 1
    var isSearched: Bool = false
    var currentSectionValue: [Int] = [1, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func configureView() {
        navigationItem.title = NavigationTitle.photoSearch.title
        
        searchBar.delegate = self
        
        sortButton.backgroundColor = .white
        sortButton.addTarget(self, action: #selector(sortButtonDidTapped), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: emptyCellIdentifier)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
    }
    
    override func configureHierarchy() {
        view.addSubviews(searchBar, sortButton, collectionView)
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.trailing.equalToSuperview().inset(4)
        }
         
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadSearchedPhoto(_ keyword: String) {
        networkManager.getSearchPhotos(keyword, page: currentPage) { value, error in
            if let error {
                print(error) //  임시
                return
            } else if let value {
                self.currentSectionValue[0] = 0
                if value.results.count < 1 {
                    self.currentSectionValue[1] = 1
                    self.currentSectionValue[2] = 0
                } else {
                    self.photos.append(contentsOf: value.results)
                    self.currentSectionValue[1] = 0
                    self.currentSectionValue[2] = self.photos.count
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc
    func sortButtonDidTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        loadSearchedPhoto(keyword)
        view.endEditing(true)
    }
}

extension PhotoSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(indexPath.section) else {
            print("Unknown section")
            return .zero
        }
        
        switch section {
        case .empty(_):
            let width: CGFloat = view.frame.width
            let height: CGFloat = collectionView.frame.height
            return CGSize(width: width, height: height)
        case .photos:
            let spacing: CGFloat = 3
            let inset: CGFloat = 5
            let width = UIScreen.main.bounds.width - (spacing + inset * 2)
            return CGSize(width: width / 2, height: 200)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = Section(section) else {
            print("Unknown section")
            return .zero
        }
        
        switch section {
        case .empty(_):
            return 0
        case .photos:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = Section(section) else {
            print("Unknown section")
            return .zero
        }
        
        switch section {
        case .empty(_):
            return 0
        case .photos:
            return 3
        }
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSectionValue[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(indexPath.section) else {
            print("Unknown section")
            return UICollectionViewCell()
        }
        
        switch section {
        case .empty(let emptyKind):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellIdentifier, for: indexPath) as? EmptyCollectionViewCell else {
                print("Failed to cast cell")
                return UICollectionViewCell()
            }
            cell.configure(with: emptyKind.description)
            return cell
            
        case .photos:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
                print("Failed to cast cell")
                return UICollectionViewCell()
            }
            let photo = photos[indexPath.item]
            cell.configure(with: photo)
            return cell
        }
    }
}
