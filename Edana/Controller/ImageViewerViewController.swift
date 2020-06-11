//
//  ImageViewerViewController.swift
//  Edana
//
//  Created by TinhPV on 6/11/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    @IBOutlet weak var zoomImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageToZoom: UIImage?
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let image = imageToZoom {
            zoomImageView.image = image
        }
        
        topView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleDismiss(_:))))
    }
    
    fileprivate func setupImage() {
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleImageTapped)))
        
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self 
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func handleDismiss(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc func handleImageTapped() {
        topView.isHidden = !topView.isHidden
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ImageViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
}
