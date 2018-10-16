//
//  ChatMessageController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 16/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var isComming : Bool! {
        didSet {
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 8
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        addSubview(bubbleBackgroundView)
        
        
        addSubview(messageLabel)
//        messageLabel.backgroundColor = .green
        messageLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dictum aliquet efficitur. Etiam non fringilla arcu."
        messageLabel.numberOfLines = 0
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constrains
        let constraints = [messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
//            messageLabel.widthAnchor.constraint(equalToConstant: 250),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
            ]
        
        NSLayoutConstraint.activate(constraints)
        
        
//        messageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
