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
        }
    }
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
    
    
    @IBAction func registerButtonPressed(_ sender: PrimaryButton) {
        guard let email = loginTextField.text, let _ = passwordTextField.text, let name = nameTextField.text else {print("Email or password is invalid"); return}
        Auth.auth().createUser(withEmail: loginTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.user.uid else {return}
            
            //Success
            let reference = Database.database().reference(fromURL: "https://sup-sup-369dc.firebaseio.com/")
            let usersReference = reference.child("users").child(uid)
            let values = ["name" : name,
                          "email" : email
            ]
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
