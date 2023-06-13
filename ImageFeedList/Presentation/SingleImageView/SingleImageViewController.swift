//
//  SingleImageViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 12.06.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
/*
 final class SingleImageViewController: UIViewController {
     var image: UIImage!
     
     @IBOutlet var imageView: UIImageView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         imageView.image = image
     }
 }
 */
