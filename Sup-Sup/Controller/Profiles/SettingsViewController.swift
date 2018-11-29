//
//  SettingsViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 29/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var userName : String?
    var userEmail : String?
    var userProfileImage : UIImageView?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView! {
        didSet{
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = userName
        emailLabel.text = userEmail
        if let image = userProfileImage?.image {
            profileImage.image = image
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
    
    
}
