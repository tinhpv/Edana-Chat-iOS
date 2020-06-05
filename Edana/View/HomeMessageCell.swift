//
//  HomeMessageCell.swift
//  Edana
//
//  Created by TinhPV on 6/4/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import Kingfisher

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
        // Initialization code
    }

    func updateUI() {
        FirebaseService.loadUser(with: message!.receiverID) { (user) in
            if user != nil {
                self.friendNameLabel.text = user?.name
                self.friendProfileImageView.kf.setImage(with: user?.profileImageUrl)
                self.messageLabel.text = self.message?.text
                
                let timestampDate = Date(timeIntervalSince1970: TimeInterval(self.message!.timestamp))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss a"
                self.timeLabel.text = "\(dateFormatter.string(from: timestampDate))"
            }
        } // end firebase service
        
    }
    
}
