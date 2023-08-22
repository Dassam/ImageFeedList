//
//  ImagesListCellDelegate.swift
//  ImageFeedList
//
//  Created by Dassam on 07.08.2023.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(at indexPath: IndexPath)
}
