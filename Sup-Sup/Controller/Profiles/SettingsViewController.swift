//
//  SettingsViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 29/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UITableViewController, EditProfileControllerDelegate {
    
    
    
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
//    Delegate Methods
    func nameChanged(to name: String?) {
        userName = name
        nameLabel.text = name
    }
    
    func profileImageChanged(to imageView: UIImageView?) {
        userProfileImage = imageView
        profileImage.image = imageView?.image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let editVC = segue.destination as! EditProfileController
            editVC.delegate = self
            editVC.userName = userName
            editVC.userProfileImage = userProfileImage
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
