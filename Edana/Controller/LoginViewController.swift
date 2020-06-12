//
//  LoginViewController.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        handleDismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func setupUI() {
        emailView.layer.cornerRadius = 5
        passwordView.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 8
        signUpButton.layer.cornerRadius = 4
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
       
    func handleDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        FirebaseService.handleLogin(email: email, password: password) { (uid) in
            if let id = uid {
                FirebaseService.getUserInfo(with: id) { (user) in
                    if let user = user {
                        User.setCurrent(user, writeToUserDefaults: true)
                        
                        let homeVC = self.storyboard?.instantiateViewController(identifier: Constant.VCID.home) as! HomeViewController
                        let navigationController = UINavigationController(rootViewController: homeVC)
                        self.view.window?.rootViewController = navigationController
                        self.view.window?.makeKeyAndVisible()
                        
                    }
                } // end get user info
            } // end if let
        } // end handling login
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(identifier: Constant.VCID.register) as! RegisterViewController
        present(registerVC, animated: true, completion: nil)
    }
    
}
