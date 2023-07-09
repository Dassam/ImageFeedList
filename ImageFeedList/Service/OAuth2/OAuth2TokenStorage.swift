//
//  OAuth2TokenStorage.swift
//  ImageFeedList
//
//  Created by Dassam on 05.07.2023.
//

import UIKit

final class OAuth2TokenStorage {
    static var token: String? {
        get { UserDefaults.standard.string(forKey: "token") }
        set { UserDefaults.standard.set(newValue, forKey: "token") }
    }
}
