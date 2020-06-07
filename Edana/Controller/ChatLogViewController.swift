//
//  ChatLogViewController.swift
//  Edana
//
//  Created by TinhPV on 6/4/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatLogViewController: UIViewController {
    
    @IBOutlet weak var chatlogTableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    var messages = [Message]()
    
    var toUser: User? {
        didSet {
            navigationItem.title = toUser!.name
            loadAndObserveNewMessages()
        }
    }
    
    let fromUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        chatlogTableView.dataSource = self
        chatlogTableView.delegate = self
        chatlogTableView.register(UINib(nibName: Constant.TBID.chatCellXibName , bundle: nil), forCellReuseIdentifier: Constant.TBID.chatCell)
    }
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        guard let text = chatTextField.text else { return }
        if (!text.isEmpty) {
            FirebaseService.handleSaveTextMessage(content: text, fromID: fromUser!.uid, toID: toUser!.id) { (error) in
                if let error = error {
                    // TODO: handle error
                    print(error)
                }
            }
        } // end if empty text
    }
    
    func loadAndObserveNewMessages() {
        FirebaseService.observeMessagesForSingleChatLog(currentUserID: fromUser!.uid, partnerID: toUser!.id) { (msg) in
            if let msg = msg {
                self.messages.append(msg)
                DispatchQueue.main.async {
                    self.chatlogTableView.reloadData()
                }
            }
        } // end observing
    }

}

extension ChatLogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatlogTableView.dequeueReusableCell(withIdentifier: Constant.TBID.chatCell, for: indexPath) as! ChatCell
        cell.message = self.messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
}
