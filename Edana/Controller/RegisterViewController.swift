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
    
    let db = Firestore.firestore()
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
        print("ok")
        self.photoPicker.presentActionSheet(from: self)
    }
    

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else { return }
        
        
        let storageRef = Storage.storage().reference()
            .child("profile_images")
            .child("\(name)_\(UUID().uuidString)")
        
        if let image = profileImageView.image, let imageData = image.pngData() {
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    storageRef.downloadURL { (url, error) in
                        guard let url = url else { return }
                        
                        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                                return
                            }

                            guard let userUID = result?.user.uid else { return }
                            let userData = [
                                Constant.DBKey.name : name,
                                Constant.DBKey.email : email,
                                Constant.DBKey.profileImageUrl : url.absoluteString
                            ]

                            self.db.collection(Constant.DBKey.users).document(userUID).setData(userData, merge: true)

                            self.dismiss(animated: true, completion: nil)
                        } // end Auth
                        
                        
                    }
                } // end checking error
            } // end putData task
        } // end if let imageData
        
    }
}
