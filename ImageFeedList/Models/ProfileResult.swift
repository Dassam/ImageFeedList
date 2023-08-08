//
//  ProfileResult.swift
//  ImageFeedList
//
//  Created by Dassam on 07.08.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    var lastName: String?
    var bio: String?
}
