//
//  NewMessageViewController.swift
//  Edana
//
//  Created by TinhPV on 5/30/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var userList = [User]()

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
                    self.userList.append(User(name: userDict[Constant.DBKey.name]!, email: userDict[Constant.DBKey.email]!))
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
