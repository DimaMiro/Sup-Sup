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
        setupForm()
    }
    private func setupForm() {
        
    }
}
