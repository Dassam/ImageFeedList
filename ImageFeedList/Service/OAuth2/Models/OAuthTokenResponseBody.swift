//
//  OAuthTokenResponseBody.swift
//  ImageFeedList
//
//  Created by Dassam on 06.07.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
