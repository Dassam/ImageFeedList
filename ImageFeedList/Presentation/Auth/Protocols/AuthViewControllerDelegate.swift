//
//  AuthViewControllerDelegate.swift
//  ImageFeedList
//
//  Created by Dassam on 05.07.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
