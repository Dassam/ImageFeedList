//
//  WebViewViewControllerProtocol.swift
//  ImageFeedList
//
//  Created by Dassam on 21.08.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(_ request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
