//
//  NetworkError.swift
//  ImageFeedList
//
//  Created by Dassam on 08.08.2023.
//

import Foundation

enum NetworkError: Error {
    case codeError
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError(Error)
}

enum ParseError: Error {
    case decodeError(Error)
}
