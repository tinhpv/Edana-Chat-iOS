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

class NewMessageViewController: UITableViewController {
    
    var userList = [User]()
    var delegate: NewMessageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constant.TBID.userCellXibName , bundle: nil), forCellReuseIdentifier: Constant.TBID.userCell)
        loadAllUsers()
    }
    
    func loadAllUsers() {
        FirebaseService.getAllUsers { (users) in
            if let users = users {
                self.userList = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } // end get all users
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TBID.userCell, for: indexPath) as! UserCell
        cell.user = userList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.dismiss(animated: true) {
            self.delegate?.didFinishChooseUser(user: self.userList[indexPath.row])
        }
    }

}
