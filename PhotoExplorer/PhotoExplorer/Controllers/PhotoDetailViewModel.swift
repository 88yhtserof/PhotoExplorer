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
    }
    
    struct Output {
        let userInfoImageURL: Observable<URL?> = Observable(nil)
        let userInfoName: Observable<String?> = Observable(nil)
        let userInfoCreatedAt: Observable<String?> = Observable(nil)
        
        let photoLoadOption: Observable<(URL, CGSize)?> = Observable(nil)
        
        let photoInfoSize: Observable<String?> = Observable(nil)
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    deinit {
        
    }
    
    func transform() {
        input.selectedPhotoToPreviousVC.lazyBind { [weak self] photo in
            print("Input selectedPhotoToPreviousVC bind")
            guard let self, let photo else { return }
            configureUserInfo(photo)
            configurePhoto(photo)
            configurePhotoInfo(photo)
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
    
    func configurePhoto(_ photo: Photo) {
        guard let url = URL(string: photo.urls.raw) else {
            print("Failed to create URL")
            return
        }
        let width = photo.width
        let height = photo.height * width / photo.width
        let size = CGSize(width: width, height: height)
        
        let loadOption = (url, size)
        output.photoLoadOption.send(loadOption)
    }
    
    func configurePhotoInfo(_ photo: Photo) {
        let sizeDescription = String(format: "%.f x %.f", photo.height, photo.width)
        output.photoInfoSize.send(sizeDescription)
    }
}
