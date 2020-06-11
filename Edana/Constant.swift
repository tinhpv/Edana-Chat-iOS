//
//  Constant.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation

struct Constant {
    
    struct TBID {
        static let userCell = "user_cell"
        static let userCellXibName = "UserCell"
        static let homeMessageCeell = "home_message_cell"
        static let homeMessageCellXibName = "HomeMessageCell"
        
        static let chatCell = "chat_cell"
        static let chatCellXibName = "ChatCell"
        
        static let partnerChatCell = "partner_chat_cell"
        static let partnerChatCellXibName = "PartnerMessageCell"
    }
    
    struct DBKey {
        static let users = "users"
        static let email = "email"
        static let name = "name"
        static let profileImageUrl = "profileImageUrl"
        
        static let profileImage = "profile_images"
        static let imageMsg = "img_msg"
        
        static let chatlog = "chatlog"
        
        static let messages = "messages"
        static let text = "text"
        static let imageURL = "img_url"
        static let fromID = "sender"
        static let toID = "receiver"
        static let time = "timestamp"
        static let imageWidth = "imgWidth"
        static let imageHeight = "imgHeight"
    }
    
    struct VCID {
        static let login = "login"
        static let register = "register"
        static let home = "home"
        static let newMessage = "new_message"
        static let chatlog = "chatlog"
        static let zoomVC = "zoom_image"
    }
}
