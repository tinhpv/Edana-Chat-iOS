//
//  ImageMessageCell.swift
//  Edana
//
//  Created by TinhPV on 6/12/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

protocol ImageMessageDelegate {
    func userTapped(on image: UIImage)
}

class ImageMessageCell: UITableViewCell {

    @IBOutlet var leadingEqualAnchor: NSLayoutConstraint!
    @IBOutlet var leadingGreaterEqualAnchor: NSLayoutConstraint!
    @IBOutlet var trailingEqualAnchor: NSLayoutConstraint!
    @IBOutlet var trailingGreaterEqualAnchor: NSLayoutConstraint!
    @IBOutlet weak var mesageImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    
    var delegate: ImageMessageDelegate?
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        mesageImageView.kf.setImage(with: URL(string: message!.imageUrl!))
        setupImageMessage()
        timeLabel.text = TimeHelper.convertToTime(timestamp: message!.timestamp)
        
        if message!.chatPartnerID()! == message!.senderID {
            bubbleView.backgroundColor = UIColor(named: Constant.Color.white)
            
            leadingEqualAnchor.constant = 12
            trailingGreaterEqualAnchor.constant = 100
            leadingGreaterEqualAnchor.isActive = false
            trailingEqualAnchor.isActive = false
            
        } else {
            bubbleView.backgroundColor = UIColor(named: Constant.Color.blue)
            
            trailingEqualAnchor.constant = 12
            leadingGreaterEqualAnchor.constant = 100
            trailingGreaterEqualAnchor.isActive = false
            leadingEqualAnchor.isActive = false
         
        } // end if checking chat sender
        
    }
    
    fileprivate func setupImageMessage() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        imageWidthConstraint.constant = screenWidth * 2 / 3
        imageHeightConstraint.constant = message!.imageHeight! / message!.imageWidth! * (screenWidth * 2 / 3)
        mesageImageView.layer.cornerRadius = 7.0
        
        mesageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapImageMessage)))
        mesageImageView.isUserInteractionEnabled = true
    }
    
    @objc
    func handleTapImageMessage() {
        delegate?.userTapped(on: mesageImageView.image!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 7.0
    }
    
}
