//
//  WebViewViewControllerDelegate.swift
//  ImageFeedList
//
//  Created by Dassam on 03.07.2023.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func onAuthSuccess(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
