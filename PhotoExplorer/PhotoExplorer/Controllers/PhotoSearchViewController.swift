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
    
    lazy var mainView = PhotoSearchView(delegate: self)
    
    override func loadView() {
        view = mainView
    }
    
    let networkManager = SearchNetworkManager.shared
    var photos: [Photo] = []
    var currentPage: Int = 1
    var isSearched: Bool = false
    var currentSectionValue: [Int] = [1, 0, 0]
    var searchKeyword: String?
    var orderBy: SearchAPIContructor.OrderBy = .relevant
    var totalPage: Int?
    var isInitial: Bool = false
    var color: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func configureView() {
        navigationItem.title = NavigationTitle.photoSearch.title
        mainView.sortButton.addTarget(self, action: #selector(sortButtonDidTapped), for: .touchUpInside)
        mainView.colorFilterButtonStackView.arrangedSubviews
            .forEach{
                guard let button = $0 as? UIButton else { return }
                button.addTarget(self, action: #selector(colorFilterButtonDidTapped), for: .touchUpInside)
            }
    }
    
    private func loadSearchedPhoto(_ keyword: String, order: SearchAPIContructor.OrderBy, color: String? = nil) {
        networkManager.getSearchPhotos(keyword, page: currentPage, orderBy: order, color: color) { value, error in
            if let error {
                print(error) //  임시
                return
            } else if let value {
                self.currentPage += 1
                self.totalPage = value.total_pages
                self.currentSectionValue[0] = 0
                if self.isInitial {
                    self.currentPage = 1
                    self.photos = []
                }
                
                if value.results.count < 1 {
                    self.currentSectionValue[1] = 1
                    self.currentSectionValue[2] = 0
                } else {
                    self.photos.append(contentsOf: value.results)
                    self.currentSectionValue[1] = 0
                    self.currentSectionValue[2] = self.photos.count
                }
                self.mainView.collectionView.reloadData()
            }
        }
    }
    
    @objc
    func sortButtonDidTapped(_ sender: UIButton) {
        guard !photos.isEmpty else { return }
        mainView.collectionView.contentOffset = .zero
        let order: SearchAPIContructor.OrderBy = sender.isSelected ? .relevant : .latest
        isInitial = true
        loadSearchedPhoto(searchKeyword ?? "", order: order, color: color)
    }
    
    @objc
    private func colorFilterButtonDidTapped(_ sender: UIButton) {
        self.color = ColorFilter.Color(rawValue: sender.tag)?.title
        mainView.colorFilterButtonStackView.arrangedSubviews
            .compactMap{ $0 as? UIButton }
            .filter{ $0 != sender && $0.isSelected == true }
            .forEach{
                $0.isSelected = false
            }
        
        guard !photos.isEmpty,
              let searchKeyword,
              let color else { return }
        
        isInitial = true
        loadSearchedPhoto(searchKeyword, order: orderBy, color: color)
    }
}

//MARK: - SearchBar Delegate
extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
        let keyword = Search.validateSearchWord(text) else {
            return
        }
        isInitial = true
        searchKeyword = keyword
        let order: SearchAPIContructor.OrderBy = mainView.sortButton.isSelected ? .relevant : .latest
        loadSearchedPhoto(keyword, order: order, color: self.color)
        view.endEditing(true)
    }
}

//MARK: - CollectionView Delegate FlowLayout
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
            return CGSize(width: width / 2, height: width / 2)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    }
}

//MARK: - CollectionView Delegate
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier, for: indexPath) as? EmptyCollectionViewCell else {
                print("Failed to cast cell")
                return UICollectionViewCell()
            }
            cell.configure(with: emptyKind.description)
            return cell
            
        case .photos:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                print("Failed to cast cell")
                return UICollectionViewCell()
            }
            let photo = photos[indexPath.item]
            cell.configure(with: photo)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        let photo = photos[indexPath.item]
        let photoDetailVC = PhotoDetailViewController(photo: photo)
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

//MARK: - SearchController Delegate
extension PhotoSearchViewController: UISearchControllerDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if currentPage < (totalPage ?? 1) && scrollView.contentOffset.y >= (scrollView.contentSize.height - mainView.collectionView.frame.height) {
            loadSearchedPhoto(searchKeyword ?? "", order: orderBy)
        }
    }
}

//MARK: - CollectionView PreFetching
extension PhotoSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        isInitial = false
        for indexPath in indexPaths {
            if currentPage < (totalPage ?? 1) && (photos.count - 2) == indexPath.item {
                loadSearchedPhoto(searchKeyword ?? "", order: orderBy)
            }
        }
    }
}
