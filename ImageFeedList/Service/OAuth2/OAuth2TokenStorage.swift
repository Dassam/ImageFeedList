//
//  OAuth2TokenStorage.swift
//  ImageFeedList
//
//  Created by Dassam on 05.07.2023.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let keychainWrapper: KeychainWrapper
    
    static let shared = OAuth2TokenStorage(keychainWrapper: KeychainWrapper.standard)
    
    private init(keychainWrapper: KeychainWrapper) {
        self.keychainWrapper = keychainWrapper
    }
    
    var token: String? {
        get { keychainWrapper.string(forKey: .key(.tokenDefaultsKey)) }
        
        set {
            guard let newValue = newValue else {
                assertionFailure("token = nil")
                return
            }
            keychainWrapper.set(newValue, forKey: .key(.tokenDefaultsKey))
        }
    }
    func removeToken() {
        keychainWrapper.removeObject(forKey: .key(.tokenDefaultsKey))
    }
}
