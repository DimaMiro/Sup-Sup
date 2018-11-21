//
//  RegisterViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 01/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet{
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.borderWidth = 8
            profileImageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    var isProfileImage: Bool = false
    
    @IBOutlet weak var nameTextField: CustomTextField!{
        didSet {
            if let image = UIImage(named: "name-icon"){
                let color = UIColor.CustomColor.lightGray
                nameTextField.setIcon(image: image, withColor: color)
            }
        }
    }
    @IBOutlet weak var loginTextField: CustomTextField!{
        didSet {
            if let image = UIImage(named: "mail-icon"){
                let color = UIColor.CustomColor.lightGray
                loginTextField.setIcon(image: image, withColor: color)
            }
        }
    }
    @IBOutlet weak var passwordTextField: CustomTextField!{
        didSet {
            if let image = UIImage(named: "password-icon"){
                let color = UIColor.CustomColor.lightGray
                passwordTextField.setIcon(image: image, withColor: color)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    @IBAction func registerButtonPressed(_ sender: PrimaryButton) {
        guard let email = loginTextField.text, let _ = passwordTextField.text, let name = nameTextField.text else {print("Email or password is invalid"); return}
        Auth.auth().createUser(withEmail: loginTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.user.uid else {return}
            
            //Success
            
            if self.isProfileImage {
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                
                if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
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
                                "name" : name,
                                "email" : email,
                                "profileImageUrl" : downloadUrl
                                ] as [String : AnyObject]
                            self.registerUserIntoDatabase(withUid: uid, andValues: values as [String : AnyObject])
                        })
                        
                    })
                }
            } else {
                let values = [
                    "name" : name,
                    "email" : email
                    ] as [String : AnyObject]
                self.registerUserIntoDatabase(withUid: uid, andValues: values as [String : AnyObject])
            }
            
        }
    }
    
    private func registerUserIntoDatabase(withUid uid: String, andValues values : [String : AnyObject]) {
        let reference = Database.database().reference()
        let usersReference = reference.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("Registration has been failed")
                return
            }
            self.performSegue(withIdentifier: "goToLoginAfterRegistration", sender: nil)
            print("Save user succsessfully")
        })
    }
    
}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            profileImageView.image = selectedImage
            isProfileImage = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
