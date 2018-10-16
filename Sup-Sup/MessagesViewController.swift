//
//  ViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 15/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {
    
    fileprivate let cellId = "messageID"
    let messagesArray = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dictum aliquet efficitur.",
                         "Etiam non fringilla arcu.",
                         "Quisque interdum volutpat ultricies. Maecenas ex ipsum, tristique laoreet tortor at, venenatis accumsan elit."]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.messageLabel.text = messagesArray[indexPath.row]
        
        return cell
    }
    
}

