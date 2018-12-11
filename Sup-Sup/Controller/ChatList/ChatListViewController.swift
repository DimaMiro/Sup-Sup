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
    var messagesDictionary = [String : ChatMessage]()
    
    var currentUserName : String?
    var currentUserEmail : String?
    
    let currentUserProfileImage : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profilePicPlaceholder"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = 18
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        checkIfUserIsLoggedIn()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.tableFooterView = UIView()
        
    }
    fileprivate func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogOut()
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                self.resetChatList()
            }, withCancel: nil)
        }
    }
    
    func resetChatList(){
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
    }
    
    fileprivate func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        navigationController?.navigationBar.tintColor = UIColor.CustomColor.electricPurple
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let leftBarButton = UIBarButtonItem(customView: currentUserProfileImage)

        leftBarButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        leftBarButton.customView?.widthAnchor.constraint(equalToConstant: 36).isActive = true
        leftBarButton.customView?.heightAnchor.constraint(equalToConstant: 36).isActive = true
        leftBarButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userActionSheet)))

        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let userInfo = snapshot.value as? [String : AnyObject] {
                    let name = userInfo["name"]
                    self.currentUserName = name as? String
                    let email = userInfo["email"]
                    self.currentUserEmail = email as? String
                    
                    if let userProfileImageURL = userInfo["profileImageUrl"] {
                        let url = URL(string: userProfileImageURL as! String)
                        URLSession.shared.dataTask(with: url!) { (data, response, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                if let dowloadedImage = UIImage(data: data!) {
                                    self.currentUserProfileImage.setImage(dowloadedImage, for: .normal)
                                }
                            }
                            }.resume()
                    }

                    
                }
            }, withCancel: nil)
        }
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    //MARK: - Handlers
    @objc func userActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            self.performSegueToSettings()
        }
        let logutAction = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            self.handleLogOut()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(settingsAction)
        actionSheet.addAction(logutAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func performSegueToSettings() {
        let storyboard = UIStoryboard(name: "Profiles", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        settingsVC.userName = currentUserName
        settingsVC.userEmail = currentUserEmail
        settingsVC.userProfileImage = currentUserProfileImage.imageView
        
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
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
    
    //MARK: - Transitions
    func showChatLogController(forUser user: User) {
        let chatLogController = ChatViewController()
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    //MARK: - Observes
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("user-messages").child(uid)
//        ref.observe(.childAdded, with: { (snapshot) in
//            let userId = snapshot.key
//            print(userId)
//            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
//                let messageID = snapshot.key
//                self.fetchMessage(withMessageId: messageID)
//                print(messageID)
//            }, withCancel: nil)
//
//        }, withCancel: nil)
        
        
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            print(userId)
            ref.child(userId).queryOrdered(byChild: uid).queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
                print("Snap: \(snapshot)")
                let messageID = snapshot.key
                self.fetchMessage(withMessageId: messageID)
            }, withCancel: nil)
        }, withCancel: nil)
        
        
    }
    
//    private func fetchMessage(withMessageId messageID : String) {
//        let messageReference = Database.database().reference().child("messages").child(messageID)
//        messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String : Any] {
//                let message = ChatMessage(dictionary: dictionary)
//
//                if let chatPartnerID = message.chatPartnerID() {
//                    self.messagesDictionary[chatPartnerID] = message
//                    print(self.messagesDictionary)
//                }
//                self.attamptReloadingOfTable()
//            }
//        }, withCancel: nil)
//        messageReference.observe(.childRemoved, with: { (snapshot) in
//            self.messagesDictionary.removeValue(forKey: snapshot.key)
//            self.attamptReloadingOfTable()
//        }, withCancel: nil)
//    }
    private func fetchMessage(withMessageId messageID : String) {
        let messageReference = Database.database().reference().child("messages").child(messageID)
        messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let message = ChatMessage(dictionary: dictionary)

                if let chatPartnerID = message.chatPartnerID() {
                    self.messagesDictionary[chatPartnerID] = message
                    print(self.messagesDictionary)
                }
//                self.handleReloadTable()
                self.attamptReloadingOfTable()
            }
//            print(snapshot)
        }, withCancel: nil)
        messageReference.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
//            self.handleReloadTable()
            self.attamptReloadingOfTable()
        }, withCancel: nil)
    }
    
    private func attamptReloadingOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    // Little trick with reloading table view
    var timer : Timer?
    
    @objc func handleReloadTable() {
        
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (m1, m2) -> Bool in
            return m1.timestamp! > m2.timestamp!
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let message = messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerID() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
                if error != nil {
                    print("Failed to delete chatLog: \(error!)")
                    return
                }
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
//                self.attamptReloadingOfTable()
                self.handleReloadTable()
            }
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerID = message.chatPartnerID() else { return }
        let ref = Database.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            let user = User(dictionary: dictionary)
            user.id = chatPartnerID
            self.showChatLogController(forUser: user)
        }, withCancel: nil)
        
    }
}

