//
//  ImagesListViewController.swift
//  ImageFeedList
//
//  Created by Dassam on 01.06.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}

// MARK: Working with tableView

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
   
    /*func numberOfSections (in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = players[indexPath.row]
        
        guard let cell = playersTableView.dequeueReusableCell (withIdentifier: cellIdentifier,
                                                               for: indexPath) as? PlayersTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(
            with: PlayersTableViewCell.PlayersNameModel(
                textField: player.name
            )
        )
        return cell
    }
    
    //------------------------- Удаление игрока ------------------------//
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let playerToRemove = self.players[indexPath.row]
            self.context.delete(playerToRemove)
            do {
                try self.context.save()
            } catch {
                print("Error Message: Couldn't delet player name.")
            }
            self.fetchPlayers()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //------------------------- Изменение имени игрока ------------------------//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let player = self.players[indexPath.row]
        
        let alert = UIAlertController(title: errorMessages.renamePlayerMessage(), message: nil, preferredStyle: .alert)
        alert.addTextField() { (playerTF) in
            playerTF.text = player.name
        }
        
        alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { _ in
            let input = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (input != "") {
                guard let name = input else { return }
                
                player.name = name
                
                do {
                    try self.context.save()
                } catch {
                    print("Error Message: Couldn't edit player name.")
                }
                self.fetchPlayers()
            } else {
                self.showAlert(self.errorMessages.nonEmptyPlayerNameMessage())
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }*/
}

