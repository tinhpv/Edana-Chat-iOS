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
import FirebaseAuth
import FirebaseDatabase

struct FirebaseService {
    
    static func updateUserInfoData(of userID: String, updateData: [String : String], completion: @escaping (Error?) -> Void) {
        let userDb = Database.database().reference()
        userDb.child(Constant.DBKey.users).child(userID).updateChildValues(updateData) { (error, ref) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            } // end check error
        } // end update child
    }
    
    static func handleLogin(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(nil)
            } else {
                //update device id
                let updateData = [Constant.DBKey.deviceID : AppDelegate.DEVICE_ID]
                updateUserInfoData(of: (authResult?.user.uid)!, updateData: updateData) { (error) in
                    if error != nil {
                        completion(nil)
                    } else {
                        completion(authResult?.user.uid)
                    }
                } // end update device id
            }
        } // end Auth
    }
    
    static func handleCreateNewUser(email: String, password: String, name: String, profileImage: UIImage?, completion: @escaping (String?) -> Void) {
        if let image = profileImage {
            saveImage(in: Constant.DBKey.profileImage, image) { (url) in
                if let url = url {
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error != nil {
                            completion(nil)
                        }

                        guard let userUID = result?.user.uid else { return }
                        let userData = [
                            Constant.DBKey.name : name,
                            Constant.DBKey.email : email,
                            Constant.DBKey.profileImageUrl : url.absoluteString,
                            Constant.DBKey.deviceID : AppDelegate.DEVICE_ID
                        ]
                        
                        let db = Database.database().reference()
                        db.child(Constant.DBKey.users).child(userUID).setValue(userData) { (err, dbRef) in
                            if err != nil {
                                completion(nil)
                            } else {
                                completion(result?.user.uid)
                            }
                        } // end setValue
                    } // end Auth
                } // end check url
            } // end save
        } // end check image
    }

    
    static func getUserInfo(with uid: String, completion: @escaping (User?) -> Void) {
        let db = Database.database().reference()
        db.child(Constant.DBKey.users).child(uid).observe(.value) { (snapshot) in
            if let userDict = snapshot.value as? [String : String] {
                let user = User(
                        id: snapshot.key,
                        name: userDict[Constant.DBKey.name]!,
                        email: userDict[Constant.DBKey.email]!,
                        profileImageUrl: URL(string: userDict[Constant.DBKey.profileImageUrl]!),
                        deviceID: userDict[Constant.DBKey.deviceID]!)
                completion(user)
            } // end get snapshot value
        }
    }
    
    static func getAllUsers(completion: @escaping ([User]?) -> Void) {
        let db = Database.database().reference()
        var userList = [User]()
        db.child(Constant.DBKey.users).observe(.value) { (snapshot) in
            if let resDict = snapshot.value as? [String : AnyObject] {
                for (key, userDict) in resDict {
                    if key != Auth.auth().currentUser?.uid {
                        let user = User(
                            id: key,
                            name: userDict[Constant.DBKey.name] as! String,
                            email: userDict[Constant.DBKey.email]! as! String,
                            profileImageUrl: URL(string: userDict[Constant.DBKey.profileImageUrl]! as! String),
                            deviceID: userDict[Constant.DBKey.deviceID]! as! String)
                        userList.append(user)
                    }
                } // end for
                completion(userList)
            } else {
                completion(nil)
            } // end resDict
        }
    }
}
