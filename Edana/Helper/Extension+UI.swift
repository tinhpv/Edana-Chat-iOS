//
//  Extension+UI.swift
//  Edana
//
//  Created by TinhPV on 6/7/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

extension UIImageView {
    func maskCircle() {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(named: "Green")?.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
