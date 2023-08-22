//
//  SplashViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 05.07.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: View components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "splashScreenLogo")
        imageView.tintColor = UIColor.ypWhite
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    private let networkService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var tokenStorage = OAuth2TokenStorage.shared
    private let imagesListService = ImagesListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = tokenStorage.self.token {
            fetchProfile(with: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    private func switchToAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }
    
    private func switchToTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = .ypBlack
        tabBarController.tabBar.tintColor = .ypWhite
        
        let window = UIApplication.shared.windows.first
        window?.rootViewController = tabBarController
    }
}

// MARK: AuthViewController Case Transition

extension SplashViewController: AuthViewControllerDelegate {
    func onAuthSuccess(_ vc: AuthViewController, token: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            tokenStorage.token = token
            fetchProfile(with: token)
        }
    }
    
    private func fetchProfile(with token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                
                UIBlockingProgressHUD.dismiss()
                switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                Alert.showAlert(with: error, view: self)
            }
        }
    }
}

// MARK: - Layout

extension SplashViewController {
    
    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
