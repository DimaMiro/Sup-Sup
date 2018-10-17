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
    let date: Date
    
}

class MessagesViewController: UITableViewController {
    
    fileprivate let cellId = "messageID"
    
    let messagesArray = [
        [
            ChatMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dictum aliquet efficitur.", isIncoming: true, date: Date()),
            ChatMessage(text: "Etiam non fringilla arcu.", isIncoming: false, date: Date()),
        ],
        [
            ChatMessage(text: "Quisque interdum volutpat ultricies. Maecenas ex ipsum, tristique laoreet tortor at, venenatis accumsan elit.", isIncoming: true, date: Date()),
            ChatMessage(text: "Nulla scelerisque vel quam sed vehicula. Phasellus a massa sit amet sem commodo semper. Nam sed ornare neque.", isIncoming: true, date: Date()),
            ChatMessage(text: "Quisque eu diam consequat, consectetur nulla pulvinar, euismod felis. Suspendisse vitae ex eget lacus venenatis fringilla ut a ligula. Fusce hendrerit, ante vitae venenatis viverra, lectus odio tempus mauris, at varius enim metus ut ex.", isIncoming: false, date: Date())

        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupTableView()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return messagesArray.count
    }
    
    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .darkGray
            textColor = .white
            textAlignment = .center
            font = UIFont.boldSystemFont(ofSize: 13)
            
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            
            let originalContentSize = super.intrinsicContentSize
            
            let height = originalContentSize.height + 16
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            
            return CGSize(width: originalContentSize.width + 16, height: height)
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let firstMessageInSection = messagesArray[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM"
            let dateString = dateFormatter.string(from: firstMessageInSection.date)
            
            let label = DateHeaderLabel()
            label.text = dateString
            
            let containerView = UIView()
            
            containerView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
        }

        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let chatMessage = messagesArray[indexPath.section][indexPath.row]

        cell.chatMessage = chatMessage
        
        return cell
    }
    
    func setupNavbar () {
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView () {
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
}

