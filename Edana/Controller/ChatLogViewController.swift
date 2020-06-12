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

    
    let photoPicker = PhotoPicker()

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
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        
        let newHeight: CGFloat
        if #available(iOS 11.0, *) {
            newHeight = keyboardHeight - view.safeAreaInsets.bottom + 7
        } else {
            newHeight = keyboardHeight
        }
        
        self.inputViewBottomConstraint.constant == 7 ? (self.inputViewBottomConstraint.constant = newHeight) : (self.inputViewBottomConstraint.constant = 7)
        
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func handleDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        chatlogTableView.addGestureRecognizer(tap)
    }
    
    fileprivate func setupKeyboard() {
        handleDismissKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardShowingUp), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    fileprivate func setupUI() {
        self.navigationItem.hidesBackButton = true
        chatInputView.layer.cornerRadius = 25.0
        partnerProfileImage.maskCircle()
        
        chatlogTableView.dataSource = self
        chatlogTableView.delegate = self
       
        // text message cell register
        chatlogTableView.register(UINib(nibName: Constant.TBID.textMessageCellXibName, bundle: nil), forCellReuseIdentifier: Constant.TBID.textMessageCell)
        chatlogTableView.register(UINib(nibName: Constant.TBID.imageMessageCellXibName, bundle: nil), forCellReuseIdentifier: Constant.TBID.imageMessageCell)
        
        
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
            FirebaseService.handleSaveTextMessage(content: text, fromID: User.current.id, toID: toUser!.id) { (error) in
                if let error = error {
                    // TODO: handle error
                    print(error)
                } else {
                    NotificationService.sendNotification(to: self.toUser!.deviceID,
                                                         senderName: User.current.name,
                                                         textMsg: text,
                                                         imageUrl: nil)
                }
            }
        } // end if empty text
        
        chatTextField.text = ""
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // IMPLEMENT CALL FUNCTION
    @IBAction func callPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func sendImagePressed(_ sender: UIButton) {
        self.photoPicker.presentActionSheet(from: self)
        self.photoPicker.completionHandler = { pickedImage in
            FirebaseService.saveImage(in: Constant.DBKey.imageMsg, pickedImage) { (url) in
                guard let url = url else { return }
                FirebaseService.handleSaveImageMessage(imageUrl: url.absoluteString, imgWidth: pickedImage.size.width, imgHeight: pickedImage.size.height, fromID: User.current.id, toID: self.toUser!.id) { (error) in
                    if let error = error {
                        print(error)
                    } else {
                        NotificationService.sendNotification(to: self.toUser!.deviceID,
                                                             senderName: User.current.name,
                                                             textMsg: nil,
                                                             imageUrl: url.absoluteString)
                    }
                } // end handle save image message
            } // end upload image to firebase storage
        } // end getting image
    }
    
    func loadAndObserveNewMessages() {
        FirebaseService.observeMessagesForSingleChatLog(currentUserID: Auth.auth().currentUser!.uid, partnerID: toUser!.id) { (msg) in
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
        
        if msg.text != nil {
            let cell = chatlogTableView.dequeueReusableCell(withIdentifier: Constant.TBID.textMessageCell, for: indexPath) as! TextMessageCell
            cell.message = msg
            cell.layer.backgroundColor = UIColor.clear.cgColor
            return cell
        } else {
            let cell = chatlogTableView.dequeueReusableCell(withIdentifier: Constant.TBID.imageMessageCell, for: indexPath)
                as! ImageMessageCell
            cell.message = self.messages[indexPath.row]
            cell.delegate = self
            cell.layer.backgroundColor = UIColor.clear.cgColor
            return cell
        }
        
    }
}


extension ChatLogViewController: ImageMessageDelegate {
    func userTapped(on image: UIImage) {
        let zoomVC = self.storyboard?.instantiateViewController(identifier: Constant.VCID.zoomVC) as! ImageViewerViewController
        zoomVC.imageToZoom = image
        present(zoomVC, animated: true, completion: nil)
    }
    
    
}
