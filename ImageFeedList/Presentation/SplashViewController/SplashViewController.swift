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
    
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private var tokenStorage = OAuth2TokenStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        configureComponents()
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
        
        let window = UIApplication.shared.windows.first!
        window.rootViewController = tabBarController
    }
}

// MARK: AuthViewController Case Transition

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(with: code)
        }
    }
  
    private func fetchOAuthToken(with code: String) {
            oauth2Service.fetchAuthToken(code: code) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    tokenStorage.token = token
                    fetchProfile(with: token)
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    showAlert(with: error)
                }
            }
        }
        
        private func fetchProfile(with token: String) {
            profileService.fetchProfile(token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { [weak self] _ in
                        guard let self = self else { return }
                        self.switchToTabBarController()
                    }
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    showAlert(with: error)
                }
            }
        }
}

// MARK: - Layout

extension SplashViewController {
    private func configureComponents() {
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Alerts

extension SplashViewController {
    private func showAlert(with error: Error) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему\n" + error.localizedDescription,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Ок", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            switchToAuthViewController()
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
