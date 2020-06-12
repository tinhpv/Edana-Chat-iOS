//
//  TextMessageCell.swift
//  Edana
//
//  Created by TinhPV on 6/12/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class TextMessageCell: UITableViewCell {
    
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet var rightEqualAnchor: NSLayoutConstraint!
    @IBOutlet var rightGreaterThanEqualAnchor: NSLayoutConstraint!
    @IBOutlet var leftEqualAnchor: NSLayoutConstraint!
    @IBOutlet var leftGreaterThanEqualAnchor: NSLayoutConstraint!
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        textMessageLabel.text = message!.text!
        timeLabel.text = TimeHelper.convertToTime(timestamp: message!.timestamp)
        
        if message!.chatPartnerID()! == message!.senderID {
            bubbleView.backgroundColor = UIColor(named: Constant.Color.white)
            textMessageLabel.textColor = UIColor(named: Constant.Color.darkBlue)
            timeLabel.textColor = UIColor(named: Constant.Color.darkGray)
            
            leftEqualAnchor.constant = 12
            rightGreaterThanEqualAnchor.constant = 100
            leftGreaterThanEqualAnchor.isActive = false
            rightEqualAnchor.isActive = false
            
        } else {
            bubbleView.backgroundColor = UIColor(named: Constant.Color.blue)
            textMessageLabel.textColor = UIColor(named: Constant.Color.white)
            timeLabel.textColor = UIColor(named: Constant.Color.lightGray)
            
            rightEqualAnchor.constant = 12
            leftGreaterThanEqualAnchor.constant = 100
            rightGreaterThanEqualAnchor.isActive = false
            leftEqualAnchor.isActive = false
         
        } // end if checking chat sender
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 7.0
    }

    
}
