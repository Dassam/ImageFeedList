//
//  ImagesListPresenter.swift
//  ImageFeedList
//
//  Created by Dassam on 22.08.2023.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get }
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func heightForRow(at indexPath: IndexPath, with tableViewWidth: CGFloat) -> CGFloat
    func rowDidSelect(at indexPath: IndexPath)
    func cellWillDisplay(at indexPath: IndexPath)
    func likeDidTapped(at indexPath: IndexPath)
    func modelForCell(at indexPath: IndexPath) -> ImagesListCellModel
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    private var photos: [Photo] = []
    private let imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        addObserver()
        fetchPhotosNextPage()
    }
    
    func numberOfRowsInSection() -> Int { photos.count }
    
    func heightForRow(at indexPath: IndexPath, with tableViewWidth: CGFloat) -> CGFloat {
        let size = photos[indexPath.row].size
        let imageViewWidth = tableViewWidth - 32
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let imageHeight = size.height * scale
        let imageViewHeight = imageHeight + 8
        return imageViewHeight
    }
    
    func modelForCell(at indexPath: IndexPath) -> ImagesListCellModel {
        ImagesListCellModel(
            imageURL: photos[indexPath.row].thumbImageURL,
            imageIsLiked: photos[indexPath.row].isLiked,
            date: photos[indexPath.row].createdAt
        )
    }
    
    func rowDidSelect(at indexPath: IndexPath) {
        let vc = SingleImageViewController()
        let photo = photos[indexPath.row]
        vc.photo = photo
        vc.modalPresentationStyle = .fullScreen
        view?.showSingleImageVC(vc)
    }
    
    func cellWillDisplay(at indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            fetchPhotosNextPage()
        }
    }
    
    func likeDidTapped(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        view?.showProgressHUD()
        imagesListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.photos[indexPath.row] = imagesListService.photos[indexPath.row]
                view?.reloadRows(at: [indexPath])
            case .failure(let error):
                print(error.localizedDescription)
                view?.showErrorAlert(error: error)
            }
            view?.dismissProgressHUD()
        }
    }
    
    func addObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.calculateIndexPaths()
            }
        )
    }
    
    private func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("Success downloading photos")
            case .failure(let error):
                print(error.localizedDescription)
                view?.showErrorAlert(error: error)
            }
        }
    }
    
    private func calculateIndexPaths() {
        let startIndex = photos.count
        let lastIndex = imagesListService.photos.count
        photos.append(contentsOf: imagesListService.photos[startIndex..<lastIndex])
        
        let indexPaths = (startIndex..<lastIndex).map {
            IndexPath(row: $0, section: 0)
        }
        view?.updateTableViewAnimated(at: indexPaths)
    }
}
