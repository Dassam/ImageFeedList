//
//  ProfileViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 12.06.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    // MARK: View components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor.ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: self,
            action: #selector(logOutButtonPressed)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    deinit {
        removeObserver()
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .ypBlack
        setupView()
        layoutComponents()
        loadData()
        addObserver()
        updateProfileDetails()
        super.viewDidLoad()
    }
    
    private func updateProfileDetails() {
        
        guard let profile = profileService.profile else { return }
        nameLabel.text = "\(profile.firstName) \(profile.lastName ?? "")"
        loginNameLabel.text = "@\(profile.username)"
        descriptionLabel.text = profile.bio
        
        if let imageURL = ProfileImageService.shared.avatarURL,
           let url = URL(string: imageURL) {
            setAvatar(url)
        }
    }
    
    private func setAvatar(_ url: URL) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 36)
        
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor), .transition(.fade(1))]
        )
    }
    
    @objc
    private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        
        setAvatar(url)
    }
    
    @objc private func logOutButtonPressed() {
        let alertController = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.cleanAndSwitchToSplashVC()
        }
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true)
    }
    
    private func cleanAndSwitchToSplashVC() {
        cleanCookies()
        OAuth2TokenStorage.shared.removeToken()
        let window = UIApplication.shared.windows.first
        let splashVC = SplashViewController()
        window?.rootViewController = splashVC
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

// MARK: - Layout

extension ProfileViewController {
    private func layoutComponents() {
        
        // MARK: - Profile Vertical Stack
        
        let vertStack = UIStackView()
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        vertStack.axis = .vertical
        vertStack.spacing = 8
        vertStack.alignment = .leading
        view.addSubview(vertStack)
        
        // MARK: - Profile Horizontal Stack
        
        let horizStack = UIStackView()
        let horizStackMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        horizStack.translatesAutoresizingMaskIntoConstraints = false
        horizStack.layoutMargins = horizStackMargins
        horizStack.axis = .horizontal
        horizStack.distribution = .fill
        horizStack.alignment = .center
        
        horizStack.addArrangedSubview(avatarImageView)
        horizStack.addArrangedSubview(UIView())
        horizStack.addArrangedSubview(logoutButton)

        vertStack.addArrangedSubview(horizStack)
        vertStack.addArrangedSubview(nameLabel)
        vertStack.addArrangedSubview(loginNameLabel)
        vertStack.addArrangedSubview(descriptionLabel)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            vertStack.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 32),
            vertStack.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 16),
            vertStack.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -16),
            horizStack.widthAnchor.constraint(
                equalTo: vertStack.widthAnchor)
        ])
    }
}

// MARK: - Styling
extension ProfileViewController {
    private func setupView() {
        view.backgroundColor = UIColor.ypBlack
    }
}

// MARK: - Data Loading
extension ProfileViewController {
    private func loadData() {
        avatarImageView.image = UIImage(named: "avatar")
        nameLabel.text = "Екатерина Новикова"
        loginNameLabel.text = "@ekaterina_nov"
        descriptionLabel.text = "Hello, world!"
    }
}

// MARK: - Observer
extension ProfileViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar(notification:)),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
}
