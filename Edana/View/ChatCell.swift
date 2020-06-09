//
//  ChatCell.swift
//  Edana
//
//  Created by TinhPV on 6/5/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var textContentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chatBackgroundView: UIView!
    
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
            textContentLabel.text = msg.text!
            
            // time handling
            let timestampDate = Date(timeIntervalSince1970: TimeInterval(self.message!.timestamp))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            self.timeLabel.text = "\(dateFormatter.string(from: timestampDate))"
        }
    }
    
}
