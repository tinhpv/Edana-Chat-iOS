//
//  CustomUIView.swift
//  Edana
//
//  Created by TinhPV on 6/9/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 7.0)
        self.layoutIfNeeded()
    }
}
