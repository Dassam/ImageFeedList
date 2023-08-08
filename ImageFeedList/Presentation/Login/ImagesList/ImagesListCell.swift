//
//  ImagesListCell.swift
//  ImageFeedList
//
//  Created by Dassam on 03.06.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlack
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .ypBlack
        self.selectionStyle = .none
        
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(mainView)
        mainView.addSubview(cellImageView)
        mainView.addSubview(likeButton)
        mainView.addSubview(dateLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            cellImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            cellImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            cellImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            cellImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            
            likeButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            likeButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8),
            dateLabel.widthAnchor.constraint(equalToConstant: 152),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    func configure(with model: ImagesListCellModel) {
        cellImageView.kf.indicatorType = .activity
        if let url = URL(string: model.imageURL) {
            cellImageView.kf.setImage(with: url, placeholder: UIImage(named: "stub")) { [weak self] _ in
                guard let self = self else { return }
                cellImageView.kf.indicatorType = .none
            }
        }
        
        dateLabel.text = dateFormatter.string(from: model.date ?? Date())
        
        let like = model.imageIsLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(like, for: .normal)
    }
    
    @objc private func likeButtonTapped() {
        delegate?.imagesListCellDidTapLike(self)
    }
}
