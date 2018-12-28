//
//  EditProfileViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 30/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

protocol EditProfileControllerDelegate {
    func nameChanged(to name: String?)
    func profileImageChanged(to imageView: UIImageView?)
}

class EditProfileController: UITableViewController {
    
    let uid = Auth.auth().currentUser?.uid
    
    var delegate: EditProfileControllerDelegate?
    
    var userName : String?
    var userProfileImage : UIImageView?
    
    var profileImageDidChange : Bool = false
    var nameDidChange : Bool = false
    var emailDidChange : Bool = false

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
        setupUserInfo()
        
        nameTextField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
    }
    
    @objc func nameDidChange(_ textField : UITextField) {
        userName = nameTextField.text
        nameDidChange = true
        print("Name did change")
    }
    
    
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
    }
    
    func setupUserInfo() {
        nameTextField.text = userName
        if let image = userProfileImage?.image {
            profileImage.image = image
        }
    }
    
    
    @objc func handleSave() {
        if profileImageDidChange {
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let profileImage = self.userProfileImage?.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        guard let downloadUrl = url?.absoluteString else {
                            print(error!)
                            return
                        }
                        let values = [
                            "name" : self.userName,
                            "profileImageUrl" : downloadUrl
                            ] as [String : AnyObject]
                        self.updateUserInfo(withUid: self.uid!, andValues: values as [String : AnyObject])
                    })
                })
            }
            print("Profile image has changed")
            delegate!.nameChanged(to: self.userName)
            delegate!.profileImageChanged(to: self.userProfileImage)
        } else if nameDidChange {
            let values = [
                "name" : self.userName,
                ] as [String : AnyObject]
            self.updateUserInfo(withUid: self.uid!, andValues: values as [String : AnyObject])
            print("Name has changed to \(userName!)")
            delegate!.nameChanged(to: self.userName)
        } else {
            print("Do nothing with userName: \(userName!)")
        }
        navigationController?.popViewController(animated: true)
    }
    private func updateUserInfo(withUid uid: String, andValues values : [String : AnyObject]) {
        let reference = Database.database().reference()
        let usersReference = reference.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("Updating user info failed")
                return
            }
            print("Update user info succsessfully")
        })
    }
    
}

extension EditProfileController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromImagePicker : UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
            profileImage.image = selectedImage
            userProfileImage?.image = selectedImage
            profileImageDidChange = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

