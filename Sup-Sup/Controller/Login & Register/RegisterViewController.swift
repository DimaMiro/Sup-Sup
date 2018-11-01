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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
                    print(err!)
                    return
                }
                print("Save user succsessfully")
            })
        }
        
    }
    
    
    
}
