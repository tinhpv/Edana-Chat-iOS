//
//  PartnerMessageCell.swift
//  Edana
//
//  Created by TinhPV on 6/9/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import Kingfisher

class PartnerMessageCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textMessageBody: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chatBackgroundView: UIView!
    
    var previousMessage: Message?
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }
    
    var partner: User?
    
    fileprivate func updateProfile() {
        if let user = partner {
            if let url = user.profileImageUrl {
                profileImage.kf.setImage(with: url)
            }
        }
    }
    
    func updateUI() {
    
        textMessageBody.text = message!.text!
        
        if let user = partner {
            if let url = user.profileImageUrl {
                profileImage.kf.setImage(with: url)
            }
        }
        
        // time label handling
        let thisMsgTimestamp = Date(timeIntervalSince1970: TimeInterval(self.message!.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        timeLabel.text = "\(dateFormatter.string(from: thisMsgTimestamp))"
        
        
        if let lastMsg = previousMessage {
            let lastMsgTimestamp = Date(timeIntervalSince1970: TimeInterval(lastMsg.timestamp))
            let interval = thisMsgTimestamp.timeIntervalSince(lastMsgTimestamp)
            let min = interval.truncatingRemainder(dividingBy: 3600) / 60
            profileImage.isHidden = min < 1.0 ? true : false
        } // end if let lastMsg
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        chatBackgroundView.layer.cornerRadius = 7.0
        profileImage.maskCircle()
    }
    
}
