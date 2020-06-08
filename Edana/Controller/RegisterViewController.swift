//
//  RegisterViewController.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameBoxView: UIView!
    @IBOutlet weak var emailBoxView: UIView!
    @IBOutlet weak var passwordBoxView: UIView!
    @IBOutlet weak var confirmBoxView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    let photoPicker = PhotoPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        profileImageView.maskCircle()
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.updateImageProfile)))
        profileImageView.isUserInteractionEnabled = true
        
        self.photoPicker.completionHandler = { pickedImage in
            self.profileImageView.image = pickedImage
        }
        
        
        nameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        confirmTextField.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 7
        signInButton.layer.cornerRadius = 4
        confirmBoxView.layer.cornerRadius = 7
        nameBoxView.layer.cornerRadius = 7
        emailBoxView.layer.cornerRadius = 7
        passwordBoxView.layer.cornerRadius = 7
    }
    
    @objc func updateImageProfile() {
        self.photoPicker.presentActionSheet(from: self)
    }
    

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else { return }
        
        FirebaseService.handleCreateNewUser(email: email, password: password, name: name, profileImage: profileImageView.image) { error in
            if (error != nil) {
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } // end create new user
    }
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
