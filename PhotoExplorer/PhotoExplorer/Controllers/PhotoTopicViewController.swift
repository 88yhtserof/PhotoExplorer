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
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let firstCollectionViewTitleLabel = UILabel()
    let secondCollectionViewTitleLabel = UILabel()
    let thirdCollectionViewTitleLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    lazy var secondCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    lazy var thirdCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    private let photoCellIdentifier = PhotoCollectionViewCell.identifier
    private var firstPhotoDataList: [Photo] = []
    private var secondPhotoDataList: [Photo] = []
    private var thirdPhotoDataList: [Photo] = []
    
    private let topicNetworkManager = TopicsNetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
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
        
        group.notify(queue: .main) {[weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    func loadTopicPhotos(_ topic: Section, completion: @escaping () -> Void) {
        topicNetworkManager.getTopicPhotos(for: topic.query) { [self] value, _ in
            guard let value else { return }
            
            switch topic {
            case .goldenHour:
                self.firstPhotoDataList = value
                self.collectionView.reloadData()
            case .business:
                self.secondPhotoDataList = value
                self.secondCollectionView.reloadData()
            case .interior:
                self.thirdPhotoDataList = value
                self.thirdCollectionView.reloadData()
            }
            completion()
        }
    }
    
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        layout.itemSize = CGSize(width: 100, height: 200)
        return layout
    }
    
    override func configureView() {
        navigationItem.title = NavigationTitle.photoTopic.title
        navigationItem.largeTitleDisplayMode = .automatic
        
        firstCollectionViewTitleLabel.text = Section.goldenHour.title
        firstCollectionViewTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        secondCollectionViewTitleLabel.text = Section.business.title
        secondCollectionViewTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        thirdCollectionViewTitleLabel.text = Section.interior.title
        thirdCollectionViewTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
        collectionView.tag = 0
        collectionView.showsHorizontalScrollIndicator = false
        
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self
        secondCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
        secondCollectionView.tag = 1
        secondCollectionView.showsHorizontalScrollIndicator = false
        
        thirdCollectionView.delegate = self
        thirdCollectionView.dataSource = self
        thirdCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
        thirdCollectionView.tag = 2
        thirdCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func configureHierarchy() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(firstCollectionViewTitleLabel, collectionView, secondCollectionViewTitleLabel, secondCollectionView, thirdCollectionViewTitleLabel, thirdCollectionView)
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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

extension PhotoTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
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
