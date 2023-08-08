//
//  PhotoResult.swift
//  ImageFeedList
//
//  Created by Dassam on 08.08.2023.
//

import Foundation

struct PhotoResult: Decodable {
       let id: String
       let width: Int
       let height: Int
       let createdAt: String
       let description: String?
       let urls: UrlsResult
       let likedByUser: Bool
   }

   struct UrlsResult: Decodable {
       let thumb: String
       let regular: String
   }
