//
//  PhotoTopicViewController.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/17/25.
//

import UIKit
import SnapKit
import Alamofire

class PhotoTopicViewController: ConfigurationViewController {
    
    typealias Section = PhotoTopicView.Section
    
    private lazy var mainView = PhotoTopicView(delegate: self)
    
    private var firstPhotoDataList: [Photo] = []
    private var secondPhotoDataList: [Photo] = []
    private var thirdPhotoDataList: [Photo] = []
    private let networkManager = UnsplashNetworkManager.shared
    
    //MARK: - LifeCycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadTopics()
    }
    
    //MARK: - Configuration
    override func configureView() {
        navigationItem.title = NavigationTitle.photoTopic.title
        navigationItem.largeTitleDisplayMode = .always
    }
    
    //MARK: - Load Data
    private func loadTopics() {
        let group = DispatchGroup()
        
        group.enter()
        loadTopicPhotos(.goldenHour) {
            group.leave()
        }
        
        group.enter()
        loadTopicPhotos(.business) {
            group.leave()
        }
        
        group.enter()
        loadTopicPhotos(.interior) {
            group.leave()
        }
        
        group.notify(queue: .main) {[self] in
            self.mainView.collectionView.reloadData()
        }
    }
    
    private func loadTopicPhotos(_ topic: Section, completion: @escaping () -> Void) {
        networkManager.callRequest(api: .topic(topic.query),
                                   type: PhotoResponse.self) { value in
            switch topic {
            case .goldenHour:
                self.firstPhotoDataList = value
                self.mainView.collectionView.reloadData()
            case .business:
                self.secondPhotoDataList = value
                self.mainView.secondCollectionView.reloadData()
            case .interior:
                self.thirdPhotoDataList = value
                self.mainView.thirdCollectionView.reloadData()
            }
            completion()
        } failureHandler: { error in
            print("Error:", error)
        }

    }
}

//MARK: - CollectionView Delegate
extension PhotoTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tag = Section(rawValue: collectionView.tag) else {
            print("Unknown section")
            return 0
        }
        
        switch tag {
        case .goldenHour:
            return firstPhotoDataList.count
        case .business:
            return secondPhotoDataList.count
        case .interior:
            return thirdPhotoDataList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            print("Failed to cast cell")
            return UICollectionViewCell()
        }
        guard let tag = Section(rawValue: collectionView.tag) else {
            print("Unknown section")
            return UICollectionViewCell()
        }
        var photo: Photo
        switch tag {
        case .goldenHour:
            photo = firstPhotoDataList[indexPath.item]
        case .business:
            photo = secondPhotoDataList[indexPath.item]
        case .interior:
            photo = thirdPhotoDataList[indexPath.item]
        }
        cell.configure(with: photo)
        cell.cornerRadius(10)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tag = Section(rawValue: collectionView.tag) else {
            print("Unknown section")
            return
        }
        var photo: Photo
        switch tag {
        case .goldenHour:
            photo = firstPhotoDataList[indexPath.item]
        case .business:
            photo = secondPhotoDataList[indexPath.item]
        case .interior:
            photo = thirdPhotoDataList[indexPath.item]
        }
        
        let photoDetailVC = PhotoDetailViewController(photo: photo)
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}
