//
//  ChatListViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 02/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class ChatListViewController: UITableViewController {
    
    let cellID = "cellID"
    var messages = [ChatMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        checkIfUserIsLoggedIn()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        observeMessages()
    }
    fileprivate func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogOut()
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
            }, withCancel: nil)
        }
    }
    fileprivate func setupNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        navigationController?.navigationBar.tintColor = UIColor.CustomColor.electricPurple
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        self.performSegue(withIdentifier: "logOutSegue", sender: nil)
        print("Successfully logged out")
    }
    @objc func handleNewMessage() {
        let newChatController = NewChatViewController()
        newChatController.chatList = self
        let navController = UINavigationController(rootViewController: newChatController)
        present(navController, animated: true, completion: nil)
        
    }
    
    func showChatLogController(forUser user: User) {
        let chatLogController = ChatViewController()
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let message = ChatMessage(dictionary: dictionary)
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

