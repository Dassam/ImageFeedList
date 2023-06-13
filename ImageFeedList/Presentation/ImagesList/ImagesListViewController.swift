//
//  ImagesListViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 01.06.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        
        cell.cellImageView.image = image
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        cell.gradient.frame = cell.dateBackground.bounds
        cell.gradient.colors = cell.gradientColors
        cell.gradient.locations = [0, 1]
        cell.gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        cell.gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        
        cell.dateBackground.layer.addSublayer(cell.gradient)
        
        if indexPath.row % 2 != 0 {
            cell.likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

      guard let image = UIImage(named: "\(indexPath.row)") else {
        preconditionFailure("Image Not Found")
      }
      let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
      let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
      let imageWidth = image.size.width
      let scale = imageViewWidth / imageWidth
      let imageHeight = image.size.height * scale
      let imageViewHeight = imageHeight + imageInsets.top + imageInsets.bottom
      return imageViewHeight
    }
}

//MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
}
