//
//  ViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 15/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

struct ChatMessage {
    
    let text: String
    let isIncoming: Bool
    
}

class MessagesViewController: UITableViewController {
    
    fileprivate let cellId = "messageID"
    let messagesArray = [
        ChatMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dictum aliquet efficitur.", isIncoming: true),
        ChatMessage(text: "Etiam non fringilla arcu.", isIncoming: false),
        ChatMessage(text: "Quisque interdum volutpat ultricies. Maecenas ex ipsum, tristique laoreet tortor at, venenatis accumsan elit.", isIncoming: true),
        ChatMessage(text: "Nulla scelerisque vel quam sed vehicula. Phasellus a massa sit amet sem commodo semper. Nam sed ornare neque.", isIncoming: true),
        ChatMessage(text: "Quisque eu diam consequat, consectetur nulla pulvinar, euismod felis. Suspendisse vitae ex eget lacus venenatis fringilla ut a ligula. Fusce hendrerit, ante vitae venenatis viverra, lectus odio tempus mauris, at varius enim metus ut ex.", isIncoming: false),
    ]
//    let messagesArray = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dictum aliquet efficitur.",
//                         "Etiam non fringilla arcu.",
//                         "Quisque interdum volutpat ultricies. Maecenas ex ipsum, tristique laoreet tortor at, venenatis accumsan elit.",
//                         "Nulla scelerisque vel quam sed vehicula. Phasellus a massa sit amet sem commodo semper. Nam sed ornare neque.",
//                         "Quisque eu diam consequat, consectetur nulla pulvinar, euismod felis. Suspendisse vitae ex eget lacus venenatis fringilla ut a ligula. Fusce hendrerit, ante vitae venenatis viverra, lectus odio tempus mauris, at varius enim metus ut ex."]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let chatMessage = messagesArray[indexPath.row]

        cell.chatMessage = chatMessage
        
        return cell
    }
    
}

