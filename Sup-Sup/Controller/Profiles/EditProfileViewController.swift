//
//  EditProfileViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 30/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class EditProfileViewController: UITableViewController {
    
    var userName : String?
    var userEmail : String?
    var userProfileImage : UIImageView?

    @IBOutlet weak var profileImage: UIImageView! {
        didSet{
            profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.layer.masksToBounds = true
            
            let blackBackground = UIView()
            profileImage.addSubview(blackBackground)
            blackBackground.translatesAutoresizingMaskIntoConstraints = false
            blackBackground.backgroundColor = .black
            blackBackground.alpha = 0.3
            blackBackground.widthAnchor.constraint(equalToConstant: 60).isActive = true
            blackBackground.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            
            let changeImageIcon = UIImageView()
            profileImage.addSubview(changeImageIcon)
            changeImageIcon.translatesAutoresizingMaskIntoConstraints = false
            changeImageIcon.image = UIImage(named: "changeImageIcon")
            changeImageIcon.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
            changeImageIcon.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            
        }
    }
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        nameTextField.text = userName
        if let image = userProfileImage?.image {
            profileImage.image = image
        }
        
    }
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
    }
    
    @objc func handleSave() {
        navigationController?.popViewController(animated: true)
    }
}

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}
