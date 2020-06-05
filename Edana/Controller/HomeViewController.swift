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
    
    @IBOutlet weak var homeMessageTableView: UITableView!
    
    let db = Firestore.firestore()
    var messages = [Message]()
    var messagesDictionary: [String : Message] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeMessageTableView.delegate = self
        homeMessageTableView.dataSource = self
        homeMessageTableView.register(UINib(nibName: Constant.TBID.homeMessageCellXibName , bundle: nil), forCellReuseIdentifier: Constant.TBID.homeMessageCeell)
        
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        perform(#selector(self.handleLogout))
    }
    
    @IBAction func addNewMessagePressed(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(identifier: Constant.VCID.newMessage) as! NewMessageViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    func checkUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            self.messagesDictionary.removeAll()
            self.messages.removeAll()
            self.homeMessageTableView.reloadData()
            loadUserInfo(of: Auth.auth().currentUser!.uid)
        }
    }
    
    func loadUserInfo(of userId: String) {
        db.collection(Constant.DBKey.users).document(userId).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                self.navigationItem.title = snapshot?.data()?[Constant.DBKey.name] as? String
                self.observeNewMessages()
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
        present(loginController, animated: true, completion: nil)
    }
    
    func observeNewMessages() {
        FirebaseService.observeNewMessages(of: Auth.auth().currentUser!.uid) { (messageDict) in
            if let dict = messageDict {
                self.messagesDictionary.update(other: dict)
                self.messages = Array(self.messagesDictionary.values)
                self.messages = self.messages.sorted()
                
                DispatchQueue.main.async {
                    self.homeMessageTableView.reloadData()
                }
            } // end dict
        } // end observing msg
    }
}

extension HomeViewController: NewMessageDelegate {
    func didFinishChooseUser(user: User?) {
        if let user = user {
            if let viewController = self.storyboard?.instantiateViewController(identifier: Constant.VCID.chatlog) as? ChatLogViewController {
                viewController.toUser = user
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } // end if let
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeMessageTableView.dequeueReusableCell(withIdentifier: Constant.TBID.homeMessageCeell, for: indexPath) as! HomeMessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMsg = messages[indexPath.row]
        FirebaseService.getUserInfo(with: selectedMsg.chatPartnerID()!) { (user) in
            guard let user = user else { return }
            let vc = self.storyboard?.instantiateViewController(identifier: Constant.VCID.chatlog) as! ChatLogViewController
            vc.toUser = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
