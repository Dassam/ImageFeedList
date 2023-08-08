//
//  ProfileImageResult.swift
//  ImageFeedList
//
//  Created by Dassam on 07.08.2023.
//

import Foundation

struct ProfileImageResult: Decodable {
    let profileImage: Size
}

struct Size: Decodable {
    let small: String
    let medium: String
    let large: String
}
