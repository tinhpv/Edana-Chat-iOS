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
    @IBOutlet weak var chatInputView: UIView!
    @IBOutlet weak var partnerProfileImage: UIImageView!
    @IBOutlet weak var partnerNameLabel: UILabel!
    
    @IBOutlet weak var chatlogTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    
    var messages = [Message]()
    
    var toUser: User? {
        didSet {
            loadAndObserveNewMessages()
        }
    }
    
    let fromUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardShowingUp(_ notification: Notification) {
        guard let userInfo = (notification as Notification).userInfo,
            let value = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let newHeight: CGFloat
        if #available(iOS 11.0, *) {
            newHeight = value.height - view.safeAreaInsets.bottom + 5
        } else {
            newHeight = value.height
        }
        
        inputViewBottomConstraint.constant = newHeight
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardHiding(notification: Notification) {
        guard let userInfo = (notification as Notification).userInfo,
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        inputViewBottomConstraint.constant = 5
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    fileprivate func setupKeyboard() {
        
        self.dismissKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardShowingUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardHiding), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupUI() {
        self.navigationItem.hidesBackButton = true
        chatInputView.layer.cornerRadius = 25.0
        partnerProfileImage.maskCircle()
        
        
        chatlogTableView.dataSource = self
        chatlogTableView.delegate = self
        chatlogTableView.register(UINib(nibName: Constant.TBID.chatCellXibName , bundle: nil), forCellReuseIdentifier: Constant.TBID.chatCell)
        chatlogTableView.register(UINib(nibName: Constant.TBID.partnerChatCellXibName, bundle: nil), forCellReuseIdentifier: Constant.TBID.partnerChatCell)
        chatlogTableView.rowHeight = UITableView.automaticDimension
        chatlogTableView.estimatedRowHeight = 300
        
        if let user = toUser {
            partnerNameLabel.text = user.name
            if let url = user.profileImageUrl {
                partnerProfileImage.kf.setImage(with: url)
            }
        }
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // IMPLEMENT CALL FUNCTION
    @IBAction func callPressed(_ sender: UIButton) {
        
    }
    
    func loadAndObserveNewMessages() {
        FirebaseService.observeMessagesForSingleChatLog(currentUserID: fromUser!.uid, partnerID: toUser!.id) { (msg) in
            if let msg = msg {
                self.messages.append(msg)
                DispatchQueue.main.async {
                    self.chatlogTableView.reloadData()
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.chatlogTableView.scrollToRow(at: indexPath, at: .top, animated: false)
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
        let msg = messages[indexPath.row]
        if msg.chatPartnerID()! == msg.senderID {
            let cell = chatlogTableView.dequeueReusableCell(withIdentifier: Constant.TBID.partnerChatCell, for: indexPath)
                as! PartnerMessageCell
            cell.partner = toUser
            cell.message = self.messages[indexPath.row]
            cell.layer.backgroundColor = UIColor.clear.cgColor
            
            if (indexPath.row - 1) >= 0 {
                cell.previousMessage = messages[indexPath.row - 1]
            }
            
            return cell
        } else {
            let cell = chatlogTableView.dequeueReusableCell(withIdentifier: Constant.TBID.chatCell, for: indexPath)
                as! ChatCell
            cell.message = self.messages[indexPath.row]
            cell.layer.backgroundColor = UIColor.clear.cgColor
            return cell
        }
    }

    
}
