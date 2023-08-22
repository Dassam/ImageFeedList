//
//  ProfileViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 12.06.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func showAlertController(_ alertController: UIAlertController)
    func setAvatar(_ url: URL)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
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
            action: #selector(logoutButtonPressed)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        presenter?.addObserverForImageURL()
        updateProfileDetails()
    }
    
    deinit { presenter?.removeObserverForImageURL() }
    
    func showAlertController(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func setAvatar(_ url: URL) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 36)
        
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor), .transition(.fade(1))]
        )
    }
    
    private func updateProfileDetails() {
        if let model = presenter?.convertResultToViewModel() {
            nameLabel.text = model.name
            loginNameLabel.text = model.userName
            descriptionLabel.text = model.description
        }
        presenter?.checkImageURL()
    }
    
    @objc private func logoutButtonPressed() {
        presenter?.didTapLogoutButton()
    }
}

// MARK: - Layout

extension ProfileViewController {
       
    private func setupConstraints() {
        
        view.backgroundColor = .ypBlack
        
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
