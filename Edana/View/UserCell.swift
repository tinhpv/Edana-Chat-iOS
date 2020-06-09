//
//  UserCell.swift
//  Edana
//
//  Created by TinhPV on 5/30/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import Kingfisher

class UserCell: UITableViewCell {

    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.maskCircle()
    }
    
    func updateUI() {
        nameLabel.text = user?.name
        if let url = user?.profileImageUrl {
            DispatchQueue.main.async {
                self.profileImageView.kf.setImage(with: url)
            }
        }
    }

    
}
