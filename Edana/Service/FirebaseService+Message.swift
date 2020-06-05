//
//  FirebaseService+Message.swift
//  Edana
//
//  Created by TinhPV on 6/5/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension FirebaseService {
    
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
        
            
            db.collection(Constant.DBKey.chatlog).document(fromID).collection(toID).document(ref!.documentID).setData([ref!.documentID : 1], merge: true)
            db.collection(Constant.DBKey.chatlog).document(toID).collection(fromID).document(ref!.documentID).setData([ref!.documentID : 1], merge: true)
//            db.collection(Constant.DBKey.chatlog).document(fromID).collection(toID).setData([ref!.documentID : 1], merge: true)
//            db.collection(Constant.DBKey.chatlog).document(toID).setData([ref!.documentID : 1], merge: true)
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
    
    
    static func observeNewMessagesForEachChatLog() {
        
    }
}
