//
//  NewMessageViewController.swift
//  Edana
//
//  Created by TinhPV on 5/30/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import Firebase

protocol NewMessageDelegate {
    func didFinishChooseUser(user: User?)
}

class NewMessageViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    var userList = [User]()
    var delegate: NewMessageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: Constant.TBID.userCellXibName , bundle: nil), forCellReuseIdentifier: Constant.TBID.userCell)
        loadAllUsers()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func loadAllUsers() {
        FirebaseService.getAllUsers { (users) in
            if let users = users {
                self.userList = users
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
        } // end get all users
    }

}

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TBID.userCell, for: indexPath) as! UserCell
        cell.user = userList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                tableView.deselectRow(at: indexPath, animated: false)
        self.dismiss(animated: true) {
            self.delegate?.didFinishChooseUser(user: self.userList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
