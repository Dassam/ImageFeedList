//
//  URLRequest+Extensions.swift
//  ImageFeedList
//
//  Created by Dassam on 24.07.2023.
//

import UIKit

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL? = AuthConfiguration.standard.defaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Failed to make url")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
