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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        FirebaseService.handleLogin(email: email, password: password) { (isAuth) in
            if isAuth {
                self.dismiss(animated: true, completion: {
                    if let topVC = UIApplication.getTopViewController() as? HomeViewController {
                        topVC.loadCurrentUserInfo()
                    }
                }) // end dismiss
            } // end if bool
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(identifier: Constant.VCID.register) as! RegisterViewController
        present(registerVC, animated: true, completion: nil)
    }
    
}
