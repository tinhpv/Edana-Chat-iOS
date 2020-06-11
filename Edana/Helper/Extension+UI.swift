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
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    func enableZoom() {
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
      isUserInteractionEnabled = true
      addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
      let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
      guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
      sender.view?.transform = scale
      sender.scale = 1
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


extension UIViewController {
    
    func isSwipable() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }

    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        let minX = view.frame.width * 0.135
        var originalPosition = CGPoint.zero

        if panGesture.state == .began {
            originalPosition = view.center
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(x: translation.x, y: 0.0)

            if panGesture.location(in: view).x > minX {
                view.frame.origin = originalPosition
            }

            if view.frame.origin.x <= 0.0 {
                view.frame.origin.x = 0.0
            }
        } else if panGesture.state == .ended {
            if view.frame.origin.x >= view.frame.width * 0.5 {
                UIView.animate(withDuration: 0.2
                     , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.size.width,
                            y: self.view.frame.origin.y
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame.origin = originalPosition
                })
            }
        }
    }
}



//extension UIViewController {
//    func dismissKeyboard() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.handleDismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func handleDismissKeyboard() {
//        view.endEditing(true)
//    }
//}
