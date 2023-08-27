//
//  ImagesListViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 01.06.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get }
    func updateTableViewAnimated(at indexPaths: [IndexPath])
    func showSingleImageVC(_ vc: SingleImageViewController)
    func reloadRows(at indexPaths: [IndexPath])
    func showProgressHUD()
    func dismissProgressHUD()
    func showErrorAlert(error: Error)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        presenter?.viewDidLoad()
        setupViews()
    }
    
    func updateTableViewAnimated(at indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    /*private func addObserverError() {
     NotificationCenter.default.addObserver(
     forName: ImagesListService.didChangeNotificationError,
     object: nil,
     queue: .main,
     using: { [weak self] _ in
     guard let self = self else { return }
     if let error = imagesListService.error {
     Alert.showAlert(with: error, view: self)
     }
     }
     )
     }*/
    func showErrorAlert(error: Error){
        Alert.showAlert(with: error, view: self)
    }
    
    func showSingleImageVC(_ vc: SingleImageViewController) {
        present(vc, animated: true)
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func showProgressHUD() { UIBlockingProgressHUD.show() }
    
    func dismissProgressHUD() { UIBlockingProgressHUD.dismiss() }
    
    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection() ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { preconditionFailure("Casting error") }
        imageListCell.delegate = self
        if let model = presenter?.modelForCell(at: indexPath) {
            imageListCell.configure(with: model, at: indexPath)
        }
        return imageListCell
    }
}

// MARK: -  UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter?.heightForRow(at: indexPath, with: tableView.bounds.width) ?? 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.rowDidSelect(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows,
           visibleIndexPaths.contains(indexPath) {
            presenter?.cellWillDisplay(at: indexPath)
        }
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func likeButtonDidTapped(at indexPath: IndexPath) {
        presenter?.likeDidTapped(at: indexPath)
    }
}
