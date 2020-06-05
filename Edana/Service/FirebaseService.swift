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
    
    
    static func handleSaveTextMessage(content: String, fromID: String, toID: String, completion: @escaping (String?) -> Void) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let textData = [Constant.DBKey.text : content,
                        Constant.DBKey.fromID: fromID,
                        Constant.DBKey.toID: toID,
                        Constant.DBKey.time: timestamp] as [String : Any]
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection(Constant.DBKey.messages).addDocument(data: textData) { (error) in
            if let error = error {
                completion(error.localizedDescription)
            } // end error
            
            db.collection(Constant.DBKey.chatlog).document(fromID).setData([ref!.documentID : 1], merge: true)
            db.collection(Constant.DBKey.chatlog).document(toID).setData([ref!.documentID : 1], merge: true)
        } // end add data
    }
    
    private static func getMessage(by messageID: String, completion: @escaping (Message?) -> Void) {
        Firestore.firestore().collection(Constant.DBKey.messages)
            .document(messageID)
            .getDocument(completion: { (snapshot, error) in
                if let _ = error {
                    completion(nil)
                } else {
                    let msgDict = snapshot!.data()!
                    let senderID = msgDict[Constant.DBKey.fromID] as! String
                    let receiverID = msgDict[Constant.DBKey.toID] as! String
                    let timestamp = msgDict[Constant.DBKey.time] as! Int
                    let text = msgDict[Constant.DBKey.text] as? String
                    let newMsg = Message(senderID: senderID, receiverID: receiverID, timestamp: timestamp, text: text)
                    completion(newMsg)
                } // end handle message
            }) // end get document
    }
    
    
    static func observeNewMessages(of currentUserID: String, completion: @escaping ([String : Message]?) -> Void) {
        
        Firestore.firestore().collection(Constant.DBKey.chatlog)
            .document(currentUserID)
            .addSnapshotListener { (snapshot, error) in
            if let _ = error {
                completion(nil)
            } else {
                if let data = snapshot?.data() {
                    var messageDict: [String : Message] = [:]
                    for (key, _) in data {
                        getMessage(by: key) { (message) in
                            if let msg = message {
                                messageDict[msg.receiverID] = msg
                                completion(messageDict)
                            }
                        } // end get message
                    } // end for dict
                    
                } else {
                    completion(nil)
                }
            } // end handle message
        } // end if add observer
    }
    
    
    static func observeMessages(completion: @escaping ([String : Message]?) -> Void) {
        Firestore.firestore().collection(Constant.DBKey.messages).addSnapshotListener { (snapshot, error) in
            if let _ = error {
                completion(nil)
            } else {
                var messageDict: [String : Message] = [:]
                snapshot?.documentChanges.forEach({ (diff) in
                    if (diff.type == .added) {
                        let msgDict = diff.document.data()
                        let senderID = msgDict[Constant.DBKey.fromID] as! String
                        let receiverID = msgDict[Constant.DBKey.toID] as! String
                        let timestamp = msgDict[Constant.DBKey.time] as! Int
                        let text = msgDict[Constant.DBKey.text] as? String
                        let newMsg = Message(senderID: senderID, receiverID: receiverID, timestamp: timestamp, text: text)
                        messageDict[receiverID] = newMsg
                    }
                }) // end detect changes
                completion(messageDict)
            } // end handle message
        } // end if add observer
    }
    
    static func loadUser(with uid: String, completion: @escaping (User?) -> Void) {
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
