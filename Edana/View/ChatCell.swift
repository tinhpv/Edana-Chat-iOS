//
//  ChatCell.swift
//  Edana
//
//  Created by TinhPV on 6/5/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

protocol ImageMessageDelegate {
    func userTapped(on image: UIImage)
}

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var textContentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chatBackgroundView: UIView!
    @IBOutlet weak var imageMessage: UIImageView!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topImageAnchor: NSLayoutConstraint!
    @IBOutlet weak var bottomImageAnchor: NSLayoutConstraint!
    @IBOutlet weak var trailingImageAnchor: NSLayoutConstraint!
    @IBOutlet weak var leadingImageAnchor: NSLayoutConstraint!
    
    var delegate: ImageMessageDelegate?
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        chatBackgroundView.layer.cornerRadius = 7.0
    }
    
    func updateUI() {
        if let msg = message {
            if let text = msg.text {
                textContentLabel.text = text
                imageMessage.isHidden = true
            } else {
                imageMessage.isHidden = false
                imageMessage.kf.setImage(with: URL(string: msg.imageUrl!))
                textContentLabel.isHidden = true
                setupImageMessage()
            }
            
            // time handling
            let timestampDate = Date(timeIntervalSince1970: TimeInterval(self.message!.timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            timeLabel.text = "\(dateFormatter.string(from: timestampDate))"
        } // end if let nil message
    }
    
    fileprivate func setupImageMessage() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        imageWidthConstraint.constant = screenWidth * 2 / 3
        imageHeightConstraint.constant = message!.imageHeight! / message!.imageWidth! * (screenWidth * 2 / 3)
        imageMessage.layer.cornerRadius = 7.0
        
        imageMessage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapImageMessage)))
        imageMessage.isUserInteractionEnabled = true
    }
    
    @objc func handleTapImageMessage() {
        delegate?.userTapped(on: imageMessage.image!)
    }
    
}
