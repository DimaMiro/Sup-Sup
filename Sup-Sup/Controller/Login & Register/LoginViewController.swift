//
//  LoginViewController.swift
//  Sup-Sup
//
//  Created by Dima Miro on 20/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: CustomTextField! {
        didSet {
            if let image = UIImage(named: "mail-icon"){
                let color = UIColor.CustomColor.lightGray
                loginTextField.setIcon(image: image, withColor: color)
            }
        }
    }
    @IBOutlet weak var passwordTextField: CustomTextField! {
        didSet {
            if let image = UIImage(named: "password-icon"){
                let color = UIColor.CustomColor.lightGray
                passwordTextField.setIcon(image: image, withColor: color)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }
    fileprivate func setupNavbar() {
        navigationController?.navigationBar.tintColor = UIColor.CustomColor.electricPurple
    }
    
    @IBAction func loginButtonPressed(_ sender: PrimaryButton) {
        guard let email = loginTextField.text, let password = passwordTextField.text else {print("Email or password is invalid"); return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Authorisation has been failed")
                return
            }
            self.performSegue(withIdentifier: "goToChatList", sender: nil)
            print("Successfully logged in")
            
        }
    }
}
