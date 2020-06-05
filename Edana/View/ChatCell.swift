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
    @IBOutlet weak var chatBackgroundView: UIView!
    
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
        
    }
    
}
