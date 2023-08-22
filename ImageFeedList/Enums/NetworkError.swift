//
//  NetworkError.swift
//  ImageFeedList
//
//  Created by Dassam on 08.08.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError(Error)
    case decodeError(Error)
    case unknownError
}


