//
//  PhotoDetailViewModel.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 2/10/25.
//

import Foundation

final class PhotoDetailViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output!
    
    struct Input {
        let selectedPhotoToPreviousVC: Observable<Photo?> = Observable(nil)
        let adjustPhotoSize: Observable<CGFloat?> = Observable(nil)
        let viewDidLoad: Observable<Void> = Observable(())
    }
    
    struct Output {
        let userInfoImageURL: Observable<URL?> = Observable(nil)
        let userInfoName: Observable<String?> = Observable(nil)
        let userInfoCreatedAt: Observable<String?> = Observable(nil)
        
        let photoLoadOption: Observable<(URL, CGSize)?> = Observable(nil)
        let photoInfoSize: Observable<String?> = Observable(nil)
        
        let statisticsResultDescription: Observable<(String, String)?> = Observable(nil)
        let failureLoadPhotoStatistics: Observable<UnsplashError?> = Observable(nil)
    }
    
    private let networkManager = UnsplashNetworkManager.shared
    
    init() {
        print("PhotoDetailViewModel init")
        
        input = Input()
        output = Output()
        
        transform()
    }
    
    deinit {
        print("PhotoDetailViewModel deinit")
    }
    
    func transform() {
        input.selectedPhotoToPreviousVC.lazyBind { [weak self] photo in
            print("Input selectedPhotoToPreviousVC bind")
            guard let self, let photo else { return }
            self.configureUserInfo(photo)
            self.configurePhotoInfo(photo)
        }
        
        input.adjustPhotoSize.lazyBind { [weak self] width in
            print("Input adjustPhotoSize bind")
            guard let self,
                  let width,
                  let photo = self.input.selectedPhotoToPreviousVC.value else { return }
            
            self.configurePhoto(photo, width: width)
        }
        
        input.viewDidLoad.lazyBind { [weak self] _ in
            print("Input viewDidLoad bind")
            guard let self,
                  let photo = self.input.selectedPhotoToPreviousVC.value else { return }
            self.loadPhotoStatistics(photo.id)
        }
    }
}

private extension PhotoDetailViewModel {
    
    func configureUserInfo(_ photo: Photo) {
        let url = URL(string: photo.user.profile_image.small)
        output.userInfoImageURL.send(url)
        
        output.userInfoName.send(photo.user.name)
        
        let createdAtDateString = DateFormatterManager.shared.String(from: photo.created_at, to: .createdAt)
        let createdAtDescription = String(format: "%@ 게시됨", createdAtDateString)
        output.userInfoCreatedAt.send(createdAtDescription)
    }
    
    func configurePhoto(_ photo: Photo, width: CGFloat) {
        guard let url = URL(string: photo.urls.raw) else {
            print("Failed to create URL")
            return
        }
        
        let height = photo.height * width / photo.width
        let size = CGSize(width: width, height: height)
        
        let loadOption = (url, size)
        output.photoLoadOption.send(loadOption)
    }
    
    func configurePhotoInfo(_ photo: Photo) {
        let sizeDescription = String(format: "%.f x %.f", photo.height, photo.width)
        output.photoInfoSize.send(sizeDescription)
    }
    
    func loadPhotoStatistics(_ photoID: String) {
        networkManager.callRequest(api: .statistics(photoID: photoID),
                                   type: StatisticsResponse.self) { value in
            guard let viewsTotal = value.views.total.decimal(),
                  let downloadsTotal = value.downloads.total.decimal() else {
                print("Failed to get formatted statistics string")
                return
            }
            self.output.statisticsResultDescription.send((viewsTotal, downloadsTotal))
        } failureHandler: { error in
            self.output.failureLoadPhotoStatistics.send(error)
        }

    }
}
