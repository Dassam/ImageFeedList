//
//  ImagesListCell.swift
//  ImageFeedList
//
//  Created by Dassam on 03.06.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateBackground: UIView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    let gradient = CAGradientLayer()
    let gradientColors = [
        UIColor(red: 0.102,
                green: 0.106,
                blue: 0.133,
                alpha: 0.2).cgColor,
        UIColor(red: 0.102,
                green: 0.106,
                blue: 0.133,
                alpha: 0).cgColor
      ]
}
