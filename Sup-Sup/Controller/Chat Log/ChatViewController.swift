//
//  ChatViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 15/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase
import SimpleImageViewer

class ChatViewController: UIViewController {
    
    var user : User? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
    }

    let chatPartnerProfileImage : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profilePicPlaceholder"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = 18
        return button
    } ()
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewStyles()
        setupNavbar()
        setupTableView()
        setupMessageInput()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup View Controller method group
    private func setupViewStyles() {
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
    
    private func setupNavbar () {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let rightBarButton = UIBarButtonItem(customView: chatPartnerProfileImage)
        rightBarButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightBarButton.customView?.widthAnchor.constraint(equalToConstant: 36).isActive = true
        rightBarButton.customView?.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        if let userProfileImageURL = self.user?.profileImageUrl {
            let profileImageFromUrl = UIImageView()
            profileImageFromUrl.loadImageUsingCache(withUrlString: userProfileImageURL)
            chatPartnerProfileImage.setImage(profileImageFromUrl.image, for: .normal)
        }
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }

    private func setupMessageInput() {
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
        
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "uploadImage")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
        composeView.addSubview(uploadImageView)
        //Constraints
        uploadImageView.leadingAnchor.constraint(equalTo: composeView.leadingAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: composeView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: uploadImageView.widthAnchor).isActive = true
        
        composeView.addSubview(inputTextField)
        //Constraints
        inputTextField.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 8).isActive = true
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
    
    private func setupTableView () {
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
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Observe Messages
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
                    let indexPath : IndexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    // MARK: - Send message method group
    @objc private func handleSendAction() {
        if inputTextField.text != "" {
            let textProperty = ["text": inputTextField.text!]
            inputTextField.text = nil
            sendMessage(withProperties: textProperty)
        }
    }
    
    func sendMessageImage(withUrl imageUrl: String, ofImage image: UIImage) {
        let imageProperties = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        sendMessage(withProperties: imageProperties)
    }
    
    private func sendMessage(withProperties properties: [String : Any]){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        var values = ["fromID": fromID, "toID": toID, "timestamp": timestamp] as [String : Any]
        //Append values dictionary with property dictionary
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(toID)
            let messageID = childRef.key
            userMessagesRef.updateChildValues([messageID : timestamp])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID).child(fromID)
            recipientUserMessagesRef.updateChildValues([messageID : timestamp])
        }
    }
    
    
    
    // MARK: - Keyboard handlers
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        let keyboardAnimationDuration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double
        let safeAreaHeight = view.safeAreaInsets.bottom
        messageInputComposeViewBottomAnchor?.constant = -keyboardFrame!.height + safeAreaHeight
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: keyboardFrame!.height + 50, right: 0)
        UIView.animate(withDuration: keyboardAnimationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardAnimationDuration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double
        messageInputComposeViewBottomAnchor?.constant = 0
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
        UIView.animate(withDuration: keyboardAnimationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Zoom functionality
    func performZoomIn(forImageView image: UIImageView) {
        let imageViewerConfiguration = ImageViewerConfiguration { config in
            config.imageView = image
        }
        let imageViewerController = ImageViewerController(configuration: imageViewerConfiguration)
        present(imageViewerController, animated: true)
    }
}

// MARK: - Extension for TextField
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendAction()
        return true
    }
}

// MARK: - Extension for ImagePickerController
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleUploadImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("We selected an image")
        var selectedImageFromImagePicker : UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
            uploadToFirebaseStorage(withImage: selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadToFirebaseStorage(withImage image: UIImage) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("message-images").child("\(imageName).jpg")
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Upload has been failed with error: \(error!)")
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if let imageUrl = url?.absoluteString {
                        self.sendMessageImage(withUrl: imageUrl, ofImage: image)
                    }
                })
            }
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension for TableView
extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 250
        
        let message = messagesArray[indexPath.row]
        if let text = message.text {
            height = estimateTextSize(forText: text).height + 24
        } else if let imageWidth = message.imageWidth, let imageHeight = message.imageHeight {
            height = CGFloat(imageHeight / imageWidth * 250)
        }
        
        return height
    }
    
    private func estimateTextSize(forText text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatViewController = self

        let chatMessage = messagesArray[indexPath.row]

        cell.chatMessage = chatMessage
        
        setupMessageCell(cell: cell, message: chatMessage)
        if let messageText = chatMessage.text{
            cell.bubbleWidthConstraint?.constant = estimateTextSize(forText: messageText).width + 32
            cell.messageLabel.isHidden = false
        } else if chatMessage.imageUrl != nil {
            cell.bubbleWidthConstraint?.constant = 250
            cell.messageLabel.isHidden = true
        }
        
        return cell
    }
    
    private func setupMessageCell(cell: ChatMessageCell, message: ChatMessage){
        cell.selectionStyle = .none
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
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCache(withUrlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleBackgroundView.backgroundColor = .clear
        } else {
            cell.messageImageView.isHidden = true
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}
