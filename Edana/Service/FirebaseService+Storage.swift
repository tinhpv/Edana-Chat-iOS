//
//  FirebaseService+Storage.swift
//  Edana
//
//  Created by TinhPV on 6/10/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseStorage

extension FirebaseService {
    static func saveImage(in folder: String, _ image: UIImage, _ completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        .child(folder)
        .child("\(UUID().uuidString)")
        
        if let imageData = image.jpegData(compressionQuality: 0.1) {
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let url = url {
                            completion(url)
                        } else {
                            completion(nil)
                        }
                    } // end download
                } // end checking error
            } // end putData task
        } // end if let data
    }
}
