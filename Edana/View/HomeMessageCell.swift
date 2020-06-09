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
    @IBOutlet weak var msgBackgroundView: UIView!
    @IBOutlet weak var friendNameView: UIView!
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        msgBackgroundView.layer.cornerRadius = 10.0
        friendNameView.layer.cornerRadius = 5.0
        friendProfileImageView.maskCircle()
    }

    func updateUI() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userToFetch = message!.senderID == uid ? message!.receiverID : message!.senderID
        
        FirebaseService.getUserInfo(with: userToFetch) { (user) in
            if user != nil {
                self.friendNameLabel.text = user?.name
                self.friendProfileImageView.kf.setImage(with: user?.profileImageUrl)
                self.messageLabel.text = self.message?.text
                
                let timestampDate = Date(timeIntervalSince1970: TimeInterval(self.message!.timestamp))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm a"
                self.timeLabel.text = "\(dateFormatter.string(from: timestampDate))"
            }
        } // end firebase service
        
    }
    
}
