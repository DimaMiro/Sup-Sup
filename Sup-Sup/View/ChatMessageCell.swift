//
//  ChatMessageCell.swift
//  Sup-Sup
//
//  Created by Dima Miro on 16/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    let messageLabel : UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        return textView
    }()
    let bubbleBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColor.electricPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePicPlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var bubbleWidthConstraint : NSLayoutConstraint?
    
    var bubbleLeadingConstraint : NSLayoutConstraint?
    var bubbleTrailingConstraint : NSLayoutConstraint?
    
    var chatMessage: ChatMessage! {
        didSet{
            messageLabel.text = chatMessage.text
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(profileImageView)
        
        bubbleWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthConstraint?.isActive = true
        bubbleBackgroundView.heightAnchor.constraint(equalTo: heightAnchor, constant: -8).isActive = true
        bubbleLeadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        bubbleLeadingConstraint?.isActive = false
        bubbleTrailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        bubbleTrailingConstraint?.isActive = true

        messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 8).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -8).isActive = true
        messageLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor).isActive = true
        
        
//        backgroundColor = .clear
//
//        bubbleBackgroundView.backgroundColor = UIColor.CustomColor.electricPurple
//        bubbleBackgroundView.layer.cornerRadius = 16
//        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(bubbleBackgroundView)
//
//        addSubview(profileImageView)
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(messageLabel)
//
//        messageLabel.numberOfLines = 0
//        messageLabel.textColor = .white
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        // Set up constrains
//        let constraints = [
//
//            profileImageView.widthAnchor.constraint(equalToConstant: 36),
//            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
//            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            profileImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
//
//            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
//            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//
//            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
//            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
//            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
//            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
//            ]
//
//        NSLayoutConstraint.activate(constraints)
//
//
//        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 27)
//        leadingConstraint.isActive = false
//
//        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27)
//        trailingConstraint.isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
