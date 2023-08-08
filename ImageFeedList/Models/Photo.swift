//
//  Photo.swift
//  ImageFeedList
//
//  Created by Dassam on 30.07.2023.
//

import Foundation
    
struct PhotoModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
