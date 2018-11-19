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
    
    
    @IBOutlet weak var topImageHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupKeyboardObservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    fileprivate func setupNavbar() {
        navigationController?.navigationBar.tintColor = UIColor.CustomColor.electricPurple
    }
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        self.topImageHeightConstraint.constant = 150
        self.view.layoutIfNeeded()
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        self.topImageHeightConstraint.constant = 270
        self.view.layoutIfNeeded()
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

extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
