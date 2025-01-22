//
//  MainTabBarViewController.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/17/25.
//

import UIKit

enum NavigationTitle: String {
    case photoSearch = "SEARCH PHOTO"
    case photoDetail
    case photoTopic = "OUR TOPIC"
    
    var title: String {
        return rawValue
    }
}

class MainTabBarViewController: UITabBarController {
    
    enum TabBarItem: String {
        case photoSearch = "검색"
        case photoTopic = "토픽"
        
        var title: String {
            return rawValue
        }
        var imageName: String {
            switch self {
            case .photoSearch:
                return "magnifyingglass"
            case .photoTopic:
                return "rectangle.portrait.on.rectangle.portrait"
            }
        }
        var selectedImageName: String {
            switch self {
            case .photoSearch:
                return "magnifyingglass"
            case .photoTopic:
                return "rectangle.portrait.on.rectangle.portrait.fill"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureTabBarAppearance()
    }
    
    //MARK: - Configurations
    private func configureTabBar() {
        let photoSearchVC = PhotoSearchViewController()
        photoSearchVC.tabBarItem.title = TabBarItem.photoSearch.title
        photoSearchVC.tabBarItem.image = UIImage(systemName: TabBarItem.photoSearch.imageName)
        photoSearchVC.tabBarItem.selectedImage = UIImage(systemName: TabBarItem.photoSearch.selectedImageName)
        let photoSearchNC = UINavigationController(rootViewController: photoSearchVC)
        
        let photoTopicVC = PhotoTopicViewController()
        photoTopicVC.tabBarItem.title = TabBarItem.photoTopic.title
        photoTopicVC.tabBarItem.image = UIImage(systemName: TabBarItem.photoTopic.imageName)
        photoTopicVC.tabBarItem.selectedImage = UIImage(systemName: TabBarItem.photoTopic.selectedImageName)
        let photoTopicNC = UINavigationController(rootViewController: photoTopicVC)
        
        self.setViewControllers([photoSearchNC, photoTopicNC], animated: true)
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

