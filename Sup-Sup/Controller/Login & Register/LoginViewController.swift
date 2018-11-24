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
    
    @IBOutlet weak var loginButton: PrimaryButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    override open var shouldAutorotate: Bool {
        return false
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
        loginButton.loadingIndicatorSwitcher(isShow: true)
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            if error != nil {
                let errorAlert = UIAlertController(title: "Authorization failed", message: "Wrong Email or Password.\nPlease check it and try again.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                self.loginButton.loadingIndicatorSwitcher(isShow: false)
                print("Authorization failed")
                return
            }
            self.loginButton.loadingIndicatorSwitcher(isShow: false)
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
