//
//  SettingsViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 29/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

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
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let editVC = segue.destination as! EditProfileViewController
            editVC.userName = userName
            editVC.userProfileImage = userProfileImage
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            handleLogOut()
        }
    }
    
    func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginNavigationController
        present(loginVC, animated: true, completion: nil)
    }
    
    
}
