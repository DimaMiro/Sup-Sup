//
//  UserCell.swift
//  Sup-Sup
//
//  Created by Dima Miro on 03/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message : ChatMessage? {
        didSet {
            setupNameAndAvatar()
            
            self.detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp{
                let timeStampDate = NSDate(timeIntervalSince1970: Double(seconds))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
            }
        }
    }
    
    private func setupNameAndAvatar() {
        
        let chatPartnerID : String?
        if  message?.fromID == Auth.auth().currentUser?.uid {
            chatPartnerID = message?.toID
        } else {
            chatPartnerID = message?.fromID
        }
        
        if let id = chatPartnerID {
            let ref = Database.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject]{
                    self.textLabel?.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCache(withUrlString: profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        return label
    }()
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        setupProfileImageConstraints()
        setupTimeLabelConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    func setupProfileImageConstraints() {
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
    }
    
    func setupTimeLabelConstraints(){
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
