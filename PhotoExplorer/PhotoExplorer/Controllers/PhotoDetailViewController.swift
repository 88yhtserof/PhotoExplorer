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
    
    let viewModel = PhotoDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        bind()
    }
    
    private func bind() {
        // 이전 화면에서 데이터를 전달하기 때문에, 아래 output 로직의 클로저가 구성되기도 전에 값이 send되어버려서 lazyBind를 할 경우 호출되지 않는다.
        viewModel.output.userInfoImageURL.bind { [weak self] url in
            print("Output userInfoImageURL bind")
            self?.userInfoView.imageURL = url
        }
        
        viewModel.output.userInfoName.bind { [weak self] name in
            print("Output userInfoName bind")
            self?.userInfoView.name = name
        }
        
        viewModel.output.userInfoCreatedAt.bind { [weak self] createdAt in
            print("Output userInfoCreatedAt bind")
            self?.userInfoView.createdAt = createdAt
        }
        
        viewModel.output.photoLoadOption.lazyBind { [weak self] loadOption in
            print("Output photoLoadOption bind")
            guard let self, let (url, size) = loadOption else { return }
            imageView.kf.setImage(with: url,
                                  options: [.processor(DownsamplingImageProcessor(size: size))])
            
            imageView.snp.makeConstraints { make in
                make.height.equalTo(size.height)
            }
        }
        
        viewModel.output.photoInfoSize.bind { [weak self] info in
            print("Output photoInfoSize bind")
            guard let self, let info else { return }
            self.sizeInfoView.content = info
        }
        
        viewModel.output.statisticsResultDescription.lazyBind { [weak self] result in
            print("Output statisticsResultDescription bind")
            guard let self,
                  let viewsTotal = result?.0,
                  let downloadsTotal = result?.1 else { return }
            self.viewsInfoView.content = viewsTotal
            self.downloadsInfoView.content = downloadsTotal
        }
        
        viewModel.output.failureLoadPhotoStatistics.lazyBind {[weak self] error in
            print("Output failureLoadPhotoStatistics bind")
            guard let self, let error else { return }
            self.showOKAlert(title: "네트워크 오류", message: error.description_en)
        }
        
        viewModel.input.viewDidLoad.send()
        viewModel.input.adjustPhotoSize.send(view.frame.width)
    }
    
    override func configureView() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        
        infoBlockView.contentView = infoStackView
        imageView.backgroundColor = .gray
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
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


