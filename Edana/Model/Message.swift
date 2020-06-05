//
//  Message.swift
//  Edana
//
//  Created by TinhPV on 6/4/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation

struct Message {
    let senderID: String
    let receiverID: String
    let timestamp: Int
    let text: String?
}

extension Message: Comparable {

    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.timestamp > rhs.timestamp
    }

}
