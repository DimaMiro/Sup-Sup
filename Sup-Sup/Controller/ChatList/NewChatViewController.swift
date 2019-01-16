//
//  NewChatViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 03/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class NewChatViewController: UITableViewController {
    
    fileprivate let cellID = "cellID"
    private var users = [User]()
    private var filteredUsers = [User]()
    
    let searchController = UISearchController(searchResultsController: nil)
    private var searchbarIsEmpty : Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering : Bool {
        if searchController.isActive && !searchbarIsEmpty {
            return true
        } else {
            return false
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupSearchController()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        self.tableView.tableFooterView = UIView()
        fetchUser()
    }
    
    fileprivate func setupNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = UIColor.CustomColor.electricPurple
    }
    
    fileprivate func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = UIColor.CustomColor.electricPurple
        definesPresentationContext = true
    }
    
    fileprivate func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    //MARK: - Handlers
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        var user: User
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCache(withUrlString: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    var chatList : ChatListViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user : User
        if isFiltering {
            user = filteredUsers[indexPath.row]
            searchController.dismiss(animated: false)
            dismiss(animated: true) {
                self.chatList?.showChatLogController(forUser: user)
            }
        } else {
            user = users[indexPath.row]
            dismiss(animated: true) {
                self.chatList?.showChatLogController(forUser: user)
            }
        }
        
    }
}

extension NewChatViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContent(forSearchText: searchText)
    }
    
    private func filterContent(forSearchText searchText: String) {
        filteredUsers = users.filter({ (user) -> Bool in
            if let userName = user.name {
                return userName.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        })
        tableView.reloadData()
    }
}

