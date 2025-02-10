//
//  PhotoDetailViewController.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/19/25.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

final class PhotoDetailViewController: ConfigurationViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let userInfoView = UserInfoView()
    let imageView = UIImageView()
    let infoBlockView = InfoBlockView(title: "정보")
    let sizeInfoView = InfoView(title: "크기")
    let viewsInfoView = InfoView(title: "조회수")
    let downloadsInfoView = InfoView(title: "다운로드")
    lazy var infoStackView = UIStackView(arrangedSubviews: [sizeInfoView, viewsInfoView, downloadsInfoView])
    
    private let networkManager = UnsplashNetworkManager.shared
    
    private var photo: Photo
    private var statistics: StatisticsResponse?
    
    private let viewModel = PhotoDetailViewModel()
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadPhotoStatistics(photo.id)
    }
    
    private func loadPhotoStatistics(_ photoID: String) {
        networkManager.callRequest(api: .statistics(photoID: photoID),
                                   type: StatisticsResponse.self) { value in
            self.statistics = value
            self.viewsInfoView.content = value.views.total.decimal()
            self.downloadsInfoView.content = value.downloads.total.decimal()
        } failureHandler: { error in
            self.showOKAlert(title: "네트워크 오류", message: error.description_en)
        }

    }
    
    override func configureView() {
        
        let userInfoImageURL = URL(string: photo.user.profile_image.small)
        userInfoView.imageURL = userInfoImageURL
        userInfoView.name = photo.user.name
        let createdAtString = DateFormatterManager.shared.String(from: photo.created_at, to: .createdAt)
        userInfoView.createdAt = String(format: "%@ 게시됨", createdAtString)
        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        
        infoBlockView.contentView = infoStackView
        
        if let imageURL = URL(string: photo.urls.raw) {
            let width = view.frame.width
            let imageHeight = photo.height * width / photo.width
            let size = CGSize(width: width, height: imageHeight)
            imageView.kf.setImage(with: imageURL,
                                  options: [.processor(DownsamplingImageProcessor(size: size))])
            
            imageView.snp.makeConstraints { make in
                make.height.equalTo(imageHeight)
            }
        }
        imageView.backgroundColor = .gray
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        
        sizeInfoView.content = String(format: "%.f x %.f", photo.height, photo.width)
    }
    
    override func configureHierarchy() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(userInfoView,imageView, infoBlockView)
    }
    
    override func configureConstraints() {
        let verticalInset: CGFloat = 20
        let horizontalInset: CGFloat = 10
        let spacing: CGFloat = 15
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.verticalEdges.equalTo(scrollView)
        }
        
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(verticalInset)
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(spacing)
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
        infoBlockView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(spacing)
            make.bottom.equalToSuperview().inset(verticalInset)
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
    }
}


