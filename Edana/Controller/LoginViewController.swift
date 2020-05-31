//
//  LoginViewController.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            // success login
            self?.dismiss(animated: true, completion: nil)
            
        } // end Auth
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(identifier: Constant.VCID.register) as! RegisterViewController
        present(registerVC, animated: true, completion: nil)
    }
    
}
