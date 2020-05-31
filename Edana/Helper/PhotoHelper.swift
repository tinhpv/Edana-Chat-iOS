//
//  PhotoHelper.swift
//  Edana
//
//  Created by TinhPV on 5/31/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit

class PhotoPicker: NSObject {
    var completionHandler: ((UIImage) -> Void)?
    
    
    func presentActionSheet(from viewController: UIViewController) {
            let alertController = UIAlertController(title: nil, message: "Pick a photo from...", preferredStyle: .actionSheet)
            
            // OPTION1 - CAMERA
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
                    self.presentImagePickerController(with: .camera, from: viewController)
                }
                alertController.addAction(capturePhotoAction)
            }
            
            // OPTION2 - LIBRARY
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let uploadPhotoAction = UIAlertAction(title: "Pick from library", style: .default) { (action) in
                    self.presentImagePickerController(with: .photoLibrary, from: viewController)
                }
                alertController.addAction(uploadPhotoAction)
            }
            
            // OPTION3 - CANCEL
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // PRESENT
            viewController.present(alertController, animated: true)
            
        }
        
        func presentImagePickerController(with sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            
            viewController.present(imagePickerController, animated: true)
        }
}


extension PhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}


