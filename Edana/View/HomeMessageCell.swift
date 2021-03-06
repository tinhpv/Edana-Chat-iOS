//
//  HomeMessageCell.swift
//  Edana
//
//  Created by TinhPV on 6/4/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth

class HomeMessageCell: UITableViewCell {
    
    @IBOutlet weak var friendProfileImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        friendProfileImageView.maskCircle()
    }

    func updateUI() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userToFetch = message!.senderID == uid ? message!.receiverID : message!.senderID
        FirebaseService.getUserInfo(with: userToFetch) { (user) in
            if user != nil {
                self.friendNameLabel.text = user?.name
                self.friendProfileImageView.kf.setImage(with: user?.profileImageUrl)
                
                if let textMsg = self.message?.text {
                    self.messageLabel.text = textMsg
                } else {
                    if self.message?.senderID == userToFetch {
                        self.messageLabel.text = "\(user!.name) sent an image"
                    } else {
                        self.messageLabel.text = "You sent an image"
                    } // end handling image message
                } // end if text msg
                
                
                let timestampDate = Date(timeIntervalSince1970: TimeInterval(self.message!.timestamp))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm a"
                self.timeLabel.text = "\(dateFormatter.string(from: timestampDate))"
            }
        } // end firebase service
        
    }
    
}
