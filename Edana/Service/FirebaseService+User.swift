//
//  FirebaseService.swift
//  Edana
//
//  Created by TinhPV on 5/31/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct FirebaseService {
    
    private static func saveImage(_ image: UIImage, _ completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        .child("profile_images")
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
    
    static func handleCreateNewUser(email: String, password: String, name: String, profileImage: UIImage?, completion: @escaping () -> Void) {
        if let image = profileImage {
            saveImage(image) { (url) in
                if let url = url {
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }

                        guard let userUID = result?.user.uid else { return }
                        let userData = [
                            Constant.DBKey.name : name,
                            Constant.DBKey.email : email,
                            Constant.DBKey.profileImageUrl : url.absoluteString
                        ]

                        Firestore.firestore().collection(Constant.DBKey.users).document(userUID).setData(userData, merge: true)

                        completion()
                    } // end Auth
                    
                } // end check url
            } // end save
        } // end check image
    }

    
    static func getUserInfo(with uid: String, completion: @escaping (User?) -> Void) {
        Firestore.firestore().collection(Constant.DBKey.users).document(uid).getDocument { (snapshot, error) in
            if let _ = error {
                completion(nil)
            } else {
                let userDict = snapshot!.data() as! [String : String]
                let user = User(
                            id: snapshot!.documentID,
                            name: userDict[Constant.DBKey.name]!,
                            email: userDict[Constant.DBKey.email]!,
                            profileImageUrl: URL(string: userDict[Constant.DBKey.profileImageUrl]!))
                completion(user)
            }
        } // end get document
    }
}
