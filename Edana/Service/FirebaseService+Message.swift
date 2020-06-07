//
//  FirebaseService+Message.swift
//  Edana
//
//  Created by TinhPV on 6/5/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FirebaseService {
    
    static func handleSaveTextMessage(content: String, fromID: String, toID: String, completion: @escaping (String?) -> Void) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let textData = [Constant.DBKey.text : content,
                        Constant.DBKey.fromID: fromID,
                        Constant.DBKey.toID: toID,
                        Constant.DBKey.time: timestamp] as [String : Any]
        
        let dbReference = Database.database().reference().child(Constant.DBKey.messages).childByAutoId()
        dbReference.setValue(textData) { (error, dbRef) in
            if error != nil {
                completion(error?.localizedDescription)
            } else {
                let db = Database.database().reference()
                db.child(Constant.DBKey.chatlog).child(fromID).child(toID).updateChildValues([dbReference.key! : 1])
                db.child(Constant.DBKey.chatlog).child(toID).child(fromID).updateChildValues([dbReference.key! : 1])
                completion(nil)
            }
        } // end setvalue
    }
    
    private static func getMessage(by messageID: String, completion: @escaping (Message?) -> Void) {
        let db = Database.database().reference()
        db.child(Constant.DBKey.messages).child(messageID).observe(.value) { (snapshot) in
            if let msgDict = snapshot.value as? [String : AnyObject] {
                let senderID = msgDict[Constant.DBKey.fromID] as! String
                let receiverID = msgDict[Constant.DBKey.toID] as! String
                let timestamp = msgDict[Constant.DBKey.time] as! Int
                let text = msgDict[Constant.DBKey.text] as? String
                let newMsg = Message(senderID: senderID, receiverID: receiverID, timestamp: timestamp, text: text)
                completion(newMsg)
            } else {
                completion(nil)
            } // end if let
        } // end get value
    }
    
    
    static func observeNewMessages(of currentUserID: String, completion: @escaping (Message?) -> Void) {
        let db = Database.database().reference().child(Constant.DBKey.chatlog).child(currentUserID)
        db.observe(.childAdded) { (snapshot) in
            db.child(snapshot.key).observe(.childAdded) { (childSnapshot) in
                getMessage(by: childSnapshot.key) { (message) in
                    if let msg = message {
                        completion(msg)
                    } else {
                        completion(nil)
                    }
                } // end get message
            } // end db child
        } // end observe
    }
    
    
    static func observeMessagesForSingleChatLog(currentUserID: String, partnerID: String, completion: @escaping (Message?) -> Void) {
        let db = Database.database().reference().child(Constant.DBKey.chatlog).child(currentUserID).child(partnerID)
        db.observe(.childAdded) { (snapshot) in
            getMessage(by: snapshot.key) { (message) in
                if let message = message {
                    completion(message)
                } else {
                    completion(nil)
                }
            } // end get message
        } // end observe
    }
}
