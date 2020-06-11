//
//  HomeViewController.swift
//  Edana
//
//  Created by TinhPV on 5/30/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeMessageTableView: UITableView!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var userProfileImageview: UIImageView!
    @IBOutlet weak var nameBox: UIView!
    @IBOutlet weak var userInfoView: UIView!

    var messages = [Message]()
    var messagesDictionary: [String : Message] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeMessageTableView.delegate = self
        homeMessageTableView.dataSource = self
        homeMessageTableView.register(UINib(nibName: Constant.TBID.homeMessageCellXibName , bundle: nil), forCellReuseIdentifier: Constant.TBID.homeMessageCeell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setupNavBar()
        checkUserLoggedIn()
    }
    
    fileprivate func setupUI() {
        userProfileImageview.maskCircle()
        nameBox.layer.cornerRadius = 7
    }
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    fileprivate func updateUserUI(user: User) {
        if let profileImageURL = user.profileImageUrl {
            userProfileImageview.kf.setImage(with: profileImageURL)
        }
        
        userNameTextField.text = user.name
        emailTextField.text = user.email
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        perform(#selector(self.handleLogout))
    }
    
    @IBAction func addNewMessagePressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: Constant.VCID.newMessage) as! NewMessageViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func loadCurrentUserInfo() {
        self.messagesDictionary.removeAll()
        self.messages.removeAll()
        self.homeMessageTableView.reloadData()
        FirebaseService.getUserInfo(with: Auth.auth().currentUser!.uid) { (user) in
            guard let user = user else { return }
            self.updateUserUI(user: user)
            self.observeNewMessages()
        } // end get user
    }
    
    func checkUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            loadCurrentUserInfo()
        } // end check auth
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
        FirebaseService.observeNewMessages(of: Auth.auth().currentUser!.uid) { (msg) in
            if let message = msg {
                self.messagesDictionary[message.chatPartnerID()!] = message
                self.messages = Array(self.messagesDictionary.values)
                self.messages = self.messages.sorted()
            }
            
            
            // postpone to reload multiple times
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
        } // end observing
    }
    
    var timer: Timer?
    
    @objc func reloadTable() {
        DispatchQueue.main.async {
            self.homeMessageTableView.reloadData()
        }
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
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(95)
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
