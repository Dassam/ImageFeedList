//
//  Alert.swift
//  ImageFeedList
//
//  Created by Dassam on 10.08.2023.
//

import UIKit

final class Alert {
    
    static func showAlert(with error: Error, view: UIViewController) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему\n" + error.localizedDescription,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Ок", style: .cancel)
        
        alertController.addAction(action)
        view.present(alertController, animated: true)
    }
}
