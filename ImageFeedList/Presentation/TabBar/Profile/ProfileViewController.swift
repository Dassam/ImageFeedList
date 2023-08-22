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
    func updateProfileDetails(with model: ProfileViewModel)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    private var labelsGradientViews: Set<GradientView> = []
    private var profileImageGradientView: GradientView!
    
    // MARK: View components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
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
        button.accessibilityIdentifier = "Logout"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        addGradientViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    func showAlertController(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func setAvatar(_ url: URL) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 36)
        
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "userpick_stub"),
            options: [.processor(processor)]
        ) { [weak self] _ in
            guard let self = self else { return }
            self.profileImageGradientView.removeAllAnimations()
            self.profileImageGradientView.removeFromSuperview()
        }
    }
    
    func updateProfileDetails(with model: ProfileViewModel) {
        nameLabel.text = model.name
        loginNameLabel.text = model.userName
        descriptionLabel.text = model.description
        removeLabelAnimations()
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
    
    func addGradientViews() {
        profileImageGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 70, height: 70), cornerRadius: 35)
        let nameLabelGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 200, height: 28), cornerRadius: 14)
        let userNameLabelGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 100, height: 18), cornerRadius: 9)
        let descriptionLabelGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: 100, height: 18), cornerRadius: 9)
        
        avatarImageView.addSubview(profileImageGradientView)
        nameLabel.addSubview(nameLabelGradientView)
        loginNameLabel.addSubview(userNameLabelGradientView)
        descriptionLabel.addSubview(descriptionLabelGradientView)
        
        labelsGradientViews.insert(nameLabelGradientView)
        labelsGradientViews.insert(userNameLabelGradientView)
        labelsGradientViews.insert(descriptionLabelGradientView)
        
        [profileImageGradientView, nameLabelGradientView, userNameLabelGradientView, descriptionLabelGradientView].forEach { view in
            view?.animateGradientLayerLocations()
        }
    }
    
    func removeLabelAnimations() {
        labelsGradientViews.forEach { view in
            view.removeAllAnimations()
            view.removeFromSuperview()
        }
    }
}

// MARK: - Styling
extension ProfileViewController {
    private func setupView() {
        view.backgroundColor = UIColor.ypBlack
    }
}
