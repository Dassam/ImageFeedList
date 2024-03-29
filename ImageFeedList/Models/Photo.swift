//
//  Photo.swift
//  ImageFeedList
//
//  Created by Dassam on 30.07.2023.
//

import Foundation
    
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
