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
    
    @IBOutlet weak var bubbleLeftAnchor: NSLayoutConstraint!
    @IBOutlet weak var bubbleRightAnchor: NSLayoutConstraint!
    
    
    var message: Message? {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        textMessageLabel.text = message!.text!
        timeLabel.text = TimeHelper.convertToTime(timestamp: message!.timestamp)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
