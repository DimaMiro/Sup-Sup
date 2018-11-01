//
//  ChatViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 15/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate {
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Text your message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    
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
        setupViewStyles()
        setupNavbar()
        setupTableView()
        setupMessageInput()
        
    }
    
    func setupViewStyles() {
        let safeGuide = self.view.safeAreaLayoutGuide
        
        let background = UIImage(named: "chatLogBg")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        //Constraints
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        
    }
    
    func setupNavbar () {
        navigationItem.title = "Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    func setupMessageInput() {
        let composeView = UIView()
        let safeGuide = self.view.safeAreaLayoutGuide
        composeView.backgroundColor = .white
        composeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(composeView)
        //Constraints
        composeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        composeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        composeView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        composeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        composeView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sendButton.setTitleColor(UIColor.CustomColor.electricPurple, for: .normal)
        sendButton.addTarget(self, action: #selector(handleSendAction), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        composeView.addSubview(sendButton)
        //Constraints
        sendButton.trailingAnchor.constraint(equalTo: composeView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: composeView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: composeView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        composeView.addSubview(inputTextField)
        //Constraints
        inputTextField.leadingAnchor.constraint(equalTo: composeView.leadingAnchor, constant: 12).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: composeView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: composeView.heightAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.CustomColor.lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        composeView.addSubview(separatorLine)
        //Constraints
        separatorLine.topAnchor.constraint(equalTo: composeView.topAnchor).isActive = true
        separatorLine.leadingAnchor.constraint(equalTo: composeView.leadingAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: composeView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupTableView () {
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        
        let safeGuide = self.view.safeAreaLayoutGuide
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func handleSendAction() {
        print("Send button has been pressed")
    }
    
    @objc func handleLogOut() {
        print("Log out button has been pressed")

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendAction()
        return true
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
