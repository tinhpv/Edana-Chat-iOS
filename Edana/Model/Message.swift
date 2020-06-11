//
//  Message.swift
//  Edana
//
//  Created by TinhPV on 6/4/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Message {
    let senderID: String
    let receiverID: String
    let timestamp: Int
    let text: String?
    let imageUrl: String?
    let imageWidth: CGFloat?
    let imageHeight: CGFloat?
    
    func chatPartnerID() -> String? {
        return Auth.auth().currentUser?.uid == receiverID ? senderID : receiverID
    }
}

extension Message: Comparable {
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.timestamp > rhs.timestamp
    }
}
