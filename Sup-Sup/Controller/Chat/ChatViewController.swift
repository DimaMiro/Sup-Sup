//
//  ChatViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 15/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
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
        setupMessageInput()
        
    }
    
    
    
    func setupNavbar () {
        navigationItem.title = "Messages"
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupMessageInput() {
        let composeView = UIView()
        let safeGuide = self.view.safeAreaLayoutGuide
        composeView.backgroundColor = .white
        composeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(composeView)
        composeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        composeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        composeView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        composeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        composeView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        composeView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: composeView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: composeView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: composeView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "Text your message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        composeView.addSubview(inputTextField)
        inputTextField.leadingAnchor.constraint(equalTo: composeView.leadingAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: composeView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: composeView.heightAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupTableView () {
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.view.addSubview(tableView)
        
        let safeGuide = self.view.safeAreaLayoutGuide
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
    }
    
}

// MARK: - Extension for TableView
extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let chatMessage = messagesArray[indexPath.section][indexPath.row]
        
        cell.chatMessage = chatMessage
        
        return cell
    }
    
}
