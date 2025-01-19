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
    
    private var photo: Photo
    
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
    }
    
    override func configureView() {
        
        let url = URL(string: photo.user.profile_image.small)
        userInfoView.imageURL = url
        userInfoView.name = photo.user.name
        let createdAtString = DateFormatterManager.shared.String(from: photo.created_at, to: .createdAt)
        userInfoView.createdAt = String(format: "%@ 게시됨", createdAtString)
        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        
        infoBlockView.contentView = infoStackView
        
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .gray
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        sizeInfoView.content = String(30983872)
        viewsInfoView.content = String(134567)
        downloadsInfoView.content = String(122534)
    }
    
    override func configureHierarchy() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(userInfoView,imageView, infoBlockView)
    }
    
    override func configureConstraints() {
        let inset: CGFloat = 10
        let spacing: CGFloat = 15
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.verticalEdges.equalTo(scrollView)
        }
        
        userInfoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(inset)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(spacing)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(200) // 네트워크 통신 시 전달 받은 이미지 크기 적용
        }
        
        infoBlockView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(spacing)
            make.bottom.horizontalEdges.equalToSuperview().inset(inset)
        }
    }
}


