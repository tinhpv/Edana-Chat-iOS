//
//  RegisterViewController.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let photoPicker = PhotoPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.updateImageProfile)))
        profileImageView.isUserInteractionEnabled = true
        
        self.photoPicker.completionHandler = { pickedImage in
            self.profileImageView.image = pickedImage
        }
    }
    
    @objc func updateImageProfile() {
        self.photoPicker.presentActionSheet(from: self)
    }
    

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else { return }
        
        FirebaseService.handleCreateNewUser(email: email, password: password, name: name, profileImage: profileImageView.image) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
