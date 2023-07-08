//
//  WebViewViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 02.07.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    struct WebConstants {
        static let authorizedPath = "/oauth/authorize/native"
        static let authorizeURL = "https://unsplash.com/oauth/authorize"
        static let code = "code"
    }
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer? ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: Unsplash Authorization

private extension WebViewViewController {
    func loadWebView() {
        var components = URLComponents(string: WebConstants.authorizeURL)
        components?.queryItems = [URLQueryItem(name: "client_id", value: Constants.accessKey),
                                  URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                                  URLQueryItem(name: "response_type", value: "code"),
                                  URLQueryItem(name: "scope", value: Constants.accessScope)]
        if let url = components?.url {
            print(url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// MARK: Web Navigation

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let components = URLComponents(string: url.absoluteString),
           components.path == WebConstants.authorizedPath,
           let items = components.queryItems,
           let codeItem = items.first(where: {$0.name == WebConstants.code}) {
            return codeItem.value
        } else {
            return nil
        }
    }
}


