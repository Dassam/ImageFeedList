//
//  AuthViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 02.07.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: View components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "auth_screen_logo")
        return imageView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "Authenticate"
        return button
    }()
    
    // MARK: Init

    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }

    @objc private func buttonTapped() {
        let webViewVC = WebViewViewController()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        webViewVC.presenter = presenter
        presenter.view = webViewVC
        webViewVC.delegate = self
        webViewVC.modalPresentationStyle = .fullScreen
        present(webViewVC, animated: true)
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func onAuthSuccess(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        fetchOAuthToken(with: code)
    }
    
    private func fetchOAuthToken(with code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                delegate?.onAuthSuccess(self, token: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                Alert.showAlert(with: error, view: self)
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

// MARK: - Layout

extension AuthViewController {
    
    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.centerXAnchor.constraint( equalTo: safeArea.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.leadingAnchor.constraint( equalTo: safeArea.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint( equalTo: safeArea.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint( equalTo: safeArea.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
