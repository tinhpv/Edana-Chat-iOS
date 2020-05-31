//
//  UserCell.swift
//  Edana
//
//  Created by TinhPV on 5/30/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI() {
        nameLabel.text = user?.name
        emailLabel.text = user?.email
    }

    
}
