//
//  ProfileViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 12.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

// MARK: View components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 23)
        label.textColor = UIColor.ypWhite
        return label
    }()

    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 13)
        label.textColor = UIColor.ypGray
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 13)
        label.textColor = UIColor.ypWhite
        return label
    }()

    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.tintColor = UIColor.ypRed
        return button
    }()
    
    override func viewDidLoad() {
        setupView()
        layoutComponents()
        loadData()
        super.viewDidLoad()
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

// MARK: - Data
extension ProfileViewController {
    private func loadData() {
        avatarImageView.image = UIImage(named: "avatar")
        nameLabel.text = "Екатерина Новикова"
        loginNameLabel.text = "@ekaterina_nov"
        descriptionLabel.text = "Hello, world!"
    }
}
