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
    
    let db = Firestore.firestore()
    var userList = [User]()
    var delegate: NewMessageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constant.TBID.userCellXibName , bundle: nil), forCellReuseIdentifier: Constant.TBID.userCell)
        loadUsers()
    }
    
    func loadUsers() {
        db.collection(Constant.DBKey.users).getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                for doc in snapshot!.documents {
                    let userDict = doc.data() as! [String : String]
                    self.userList.append(User(
                        id: doc.documentID,
                        name: userDict[Constant.DBKey.name]!,
                        email: userDict[Constant.DBKey.email]!,
                        profileImageUrl: URL(string: userDict[Constant.DBKey.profileImageUrl]!)))
                } // end for ducuments
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } // end if let
        } // end get documents
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
