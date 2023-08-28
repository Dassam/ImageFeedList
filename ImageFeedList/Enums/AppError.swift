//
//  AppError.swift
//  ImageFeedList
//
//  Created by Dassam on 22.08.2023.
//

import Foundation

enum AppError: Error {
    case photoNotFound(photoId: String)
}
