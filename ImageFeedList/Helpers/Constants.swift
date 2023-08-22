//
//  Constants.swift
//  ImageFeedList
//
//  Created by Dassam on 30.06.2023.
//

import UIKit

enum Constants: String {
    case accessKey = "BcUTlbzxNTJAURJiVMu6S-vjvn-i3eRVF85CIstrEYU"
    case accessScope = "public+read_user+write_likes"
    case accessTokenURL = "https://unsplash.com/oauth/token"
    case authorizeURL = "https://unsplash.com/oauth/authorize"
    case authCodePath = "/oauth/authorize/native"
    case defaultBaseURL = "https://api.unsplash.com"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    case secretKey = "AceQ138eg17T1a0RHJ77eEE3UYGLJhu2ec9LGRELSAQ"
    case tokenDefaultsKey = "bearerToken"
}

extension String {
    static func key(_ constant: Constants) -> Self { constant.rawValue }
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let accessTokenURL: String
    let unsplashAuthorizeURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: .key(.accessKey),
            secretKey: .key(.secretKey),
            redirectURI: .key(.redirectURI),
            accessScope: .key(.accessScope),
            defaultBaseURL: URL(string: .key(.defaultBaseURL)),
            accessTokenURL: .key(.accessTokenURL),
            unsplashAuthorizeURLString: .key(.authorizeURL)
        )
    }
}
