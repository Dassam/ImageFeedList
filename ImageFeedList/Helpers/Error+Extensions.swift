//
//  Error+Extensions.swift
//  ImageFeedList
//
//  Created by Dassam on 08.08.2023.
//

import Foundation

extension Error {
    func description(of error: Error) -> String {
        switch error {
        case NetworkError.httpStatusCode(let code):
            return "Failed with status code from server - \(code)"
        case NetworkError.urlSessionError(let error):
            return "Failed with url session error - \(error)"
        case ParseError.decodeError(let error):
            return "Failed with decoding - \(error)"
        default:
            return "Unknown error - \(error)"
        }
    }
}
