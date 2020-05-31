//
//  HomeViewController.swift
//  Edana
//
//  Created by TinhPV on 5/30/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
    
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserLoggedIn()
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        perform(#selector(self.handleLogout))
    }
    
    @IBAction func addNewMessagePressed(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(identifier: Constant.VCID.newMessage) as! NewMessageViewController
        present(vc, animated: true, completion: nil)
    }
    
    
    func checkUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            loadUserInfo(of: Auth.auth().currentUser!.uid)
        }
    }
    
    func loadUserInfo(of userId: String) {
        db.collection(Constant.DBKey.users).document(userId).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                print(snapshot!.data())
            }
        } // end get docs
    }

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        } // end do-catch
        
        let loginController = self.storyboard?.instantiateViewController(identifier: Constant.VCID.login) as! LoginViewController
        present(loginController, animated: true, completion: nil )
    }
    


}
