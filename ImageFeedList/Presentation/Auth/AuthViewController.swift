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
        return button
    }()
    
    // MARK: Init

    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        configureComponents()
    }

    @objc
    private func buttonTapped() {
        let webViewVC = WebViewViewController()
        webViewVC.delegate = self
        webViewVC.modalPresentationStyle = .fullScreen
        present(webViewVC, animated: true)
    }
    
}

//MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

// MARK: - Layout

extension AuthViewController {
    private func configureComponents() {
       
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
        
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
