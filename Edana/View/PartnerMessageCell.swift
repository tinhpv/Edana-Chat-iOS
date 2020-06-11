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

    @IBOutlet weak var textMessageBody: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chatBackgroundView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }
    
    var delegate: ImageMessageDelegate?
    
    func updateUI() {
        if let text = message!.text {
            messageImageView.isHidden = true
            textMessageBody.text = text
        } else {
//            messageImageView.isHidden = false
//            messageImageView.kf.setImage(with: URL(string: message!.imageUrl!))
//            textMessageBody.isHidden = true
//            setupImageMessage()
        }
        
        // time label handling
        let thisMsgTimestamp = Date(timeIntervalSince1970: TimeInterval(self.message!.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        timeLabel.text = "\(dateFormatter.string(from: thisMsgTimestamp))"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        chatBackgroundView.layer.cornerRadius = 7.0
    }
    
    fileprivate func setupImageMessage() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        imageWidthConstraint.constant = screenWidth * 2 / 3
        imageHeightConstraint.constant = message!.imageHeight! / message!.imageWidth! * (screenWidth * 2 / 3)
        messageImageView.layer.cornerRadius = 7.0
        
        messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapImageMessage)))
        messageImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleTapImageMessage() {
        delegate?.userTapped(on: messageImageView.image!)
    }
    
    
}
