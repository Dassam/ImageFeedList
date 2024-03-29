//
//  TabBarController.swift
//  ImageFeedList
//
//  Created by Dassam on 22.07.2023.
//

import UIKit
 
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter( imagesListService: ImagesListService.shared )
        
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter()
       
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
