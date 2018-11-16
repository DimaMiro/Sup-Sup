//
//  ChatViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 15/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITextFieldDelegate {
    
    var user : User? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Text your message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    
    fileprivate var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    fileprivate let cellId = "messageID"
    var messagesArray = [ChatMessage]()

    var messageInputComposeViewBottomAnchor : NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewStyles()
        setupNavbar()
        setupTableView()
        setupMessageInput()
        setupKeyboardObservers()
        
    }
    
    fileprivate func setupViewStyles() {
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
        
        view.backgroundColor = .white
        
        //Constraints
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        
    }
    
    fileprivate func setupNavbar () {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toID = user?.id else {return}
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toID)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let messageID = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageID)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                
                guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
                let message = ChatMessage(dictionary: dictionary)
                
                self.messagesArray.append(message)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }, withCancel: nil)

        }, withCancel: nil)
    }
    
    fileprivate func setupMessageInput() {
        let composeView = UIView()
        let safeGuide = self.view.safeAreaLayoutGuide
        composeView.backgroundColor = .white
        composeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(composeView)
        //Constraints
        composeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        composeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageInputComposeViewBottomAnchor = composeView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        messageInputComposeViewBottomAnchor?.isActive = true
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
    
    fileprivate func setupTableView () {
        
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0) // Make tableView scroll with bottom gap for correct showing messageInput
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
    
    @objc fileprivate func handleSendAction() {
        print("Send button has been pressed")
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["fromID": fromID, "toID": toID, "text": inputTextField.text!, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(toID)
            let messageID = childRef.key
            userMessagesRef.updateChildValues([messageID : 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID).child(fromID)
            recipientUserMessagesRef.updateChildValues([messageID : 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendAction()
        return true
    }
    
    
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
//        print(notification.userInfo)
        let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        let keyboardAnimationDuration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double
        let safeAreaHeight = view.safeAreaInsets.bottom
        messageInputComposeViewBottomAnchor?.constant = -keyboardFrame!.height + safeAreaHeight
        UIView.animate(withDuration: keyboardAnimationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardAnimationDuration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double
        messageInputComposeViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardAnimationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - Extension for TableView
extension ChatViewController : UITableViewDelegate, UITableViewDataSource {

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return messagesArray.count
//    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if let firstMessageInSection = messagesArray[section].first {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "d MMMM"
//            let dateString = dateFormatter.string(from: firstMessageInSection.date)
//
//            let label = DateHeaderLabel()
//            label.text = dateString
//
//            let containerView = UIView()
//
//            containerView.addSubview(label)
//
//            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//            return containerView
//        }
//        return nil
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 32
        
        if let text = messagesArray[indexPath.row].text {
            height = estimateTextSize(forText: text).height + 24
        }
        
        return height
    }
    
    private func estimateTextSize(forText text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        return messagesArray[section].count
        return messagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell

//        let chatMessage = messagesArray[indexPath.section][indexPath.row]
        let chatMessage = messagesArray[indexPath.row]

        cell.chatMessage = chatMessage
        
        setupMessageCell(cell: cell, message: chatMessage)
        
        cell.bubbleWidthConstraint?.constant = estimateTextSize(forText: chatMessage.text!).width
        
        return cell
    }
    
    private func setupMessageCell(cell: ChatMessageCell, message: ChatMessage){
        
        
        
        if let userProfileImageURL = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCache(withUrlString: userProfileImageURL)
        }
        
        if message.fromID == Auth.auth().currentUser?.uid {
            // Will be purple
            cell.bubbleBackgroundView.backgroundColor = UIColor.CustomColor.electricPurple
            cell.messageLabel.textColor = .white
            cell.bubbleLeadingConstraint?.isActive = false
            cell.bubbleTrailingConstraint?.isActive = true
            cell.profileImageView.isHidden = true
            
        } else {
            // Will be gray
            cell.bubbleBackgroundView.backgroundColor = .white
            cell.messageLabel.textColor = .black
            cell.bubbleLeadingConstraint?.isActive = true
            cell.bubbleTrailingConstraint?.isActive = false
        }
    }

}
