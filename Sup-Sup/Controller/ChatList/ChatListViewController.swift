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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        checkIfUserIsLoggedIn()
        
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
    
    func showChatLogController() {
        self.performSegue(withIdentifier: "goToChatLog", sender: self)
    }
}
