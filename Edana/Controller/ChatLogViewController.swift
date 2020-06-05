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
    
    @IBOutlet weak var chatTextField: UITextField!
    
    var toUser: User? {
        didSet {
            navigationItem.title = toUser!.name
        }
    }
    
    let fromUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    

}
