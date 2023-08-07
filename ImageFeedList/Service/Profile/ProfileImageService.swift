//
//  ProfileImageService.swift
//  ImageFeedList
//
//  Created by Dassam on 21.07.2023.
//

import UIKit

final class ProfileImageService {
    
    private struct UserResult: Decodable {
        let profileImage: ProfileImage
    }
    
    private struct ProfileImage: Decodable {
        let small: String
        let medium: String
        let large: String
    }
    
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var tokenStorage = OAuth2TokenStorage.shared
        
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private init() {}
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET"),
              let token = tokenStorage.token else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result {
            case .success(let user):
                completion(.success(user.profileImage.medium))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": user.profileImage.medium]
                )
                self.avatarURL = user.profileImage.medium
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
