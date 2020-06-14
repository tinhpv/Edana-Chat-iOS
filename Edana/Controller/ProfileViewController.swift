//
//  ProfileViewController.swift
//  Edana
//
//  Created by TinhPV on 6/14/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    

    let photoPicker = PhotoPicker()
    var isProfileChanged = false
    
    override func viewWillAppear(_ animated: Bool) {
        nameView.layer.cornerRadius = 4.0
        
        nameTextField.text = User.current.name
        profileImageView.kf.setImage(with: User.current.profileImageUrl!)
        profileImageView.maskCircle()
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeProfileImage)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleDismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func handleDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    @objc
    func changeProfileImage() {
        self.photoPicker.presentActionSheet(from: self)
        self.photoPicker.completionHandler = { pickedImage in
            self.profileImageView.image = pickedImage
            self.isProfileChanged = true
        } // end getting image
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        } // end do-catch
        
        let loginController = self.storyboard?.instantiateViewController(identifier: Constant.VCID.login) as! LoginViewController
        present(loginController, animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        if isProfileChanged {
            FirebaseService.saveImage(in: Constant.DBKey.profileImage, profileImageView.image!) { (url) in
                if let url = url {
                    var user = User.current
                    user.profileImageUrl = url
                    
                    var updateData = [Constant.DBKey.profileImageUrl : url.absoluteString]
                    if let text = self.nameTextField.text {
                        if text != User.current.name {
                            updateData[Constant.DBKey.name] = text
                            user.name = text
                        }
                    }
                    
                    FirebaseService.updateUserInfoData(of: User.current.id, updateData: updateData) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            User.setCurrent(user, writeToUserDefaults: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } // end saving image
        } else {
            if let text = self.nameTextField.text {
                if text != User.current.name {
                    FirebaseService.updateUserInfoData(of: User.current.id, updateData: [Constant.DBKey.name : text]) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            var user = User.current
                            user.name = text
                            User.setCurrent(user, writeToUserDefaults: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


}
