//
//  Constant.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation

struct Constant {

    
    
    struct UserDefaults {
        static let currentUser = "currentUser"
    }
    
    struct HTTPKey {
        static let fcmServerUrl = "https://fcm.googleapis.com/fcm/send"
        static let serverKey = "AAAAxP5rxbM:APA91bHlpCDHgzev-hzVr2XgjrZS2bDZNt4Hu8tDbIq5XGGy4LeWtvtcmTKg9ZU5c-IGWcrK0MTU7zZRn2YHjE83CzPm5qxpNyWEPS1Jj67-354QnQ1lz5IKjM_U2jZnMBK0fgZfXKbg"
    }
    
    struct NotificationKey {
        static let imageURL = "urlImageString"
        static let senderID = "senderID"
    }
    
    struct TBID {
        static let userCell = "user_cell"
        static let userCellXibName = "UserCell"
        static let homeMessageCeell = "home_message_cell"
        static let homeMessageCellXibName = "HomeMessageCell"
        
        static let chatCell = "chat_cell"
        static let chatCellXibName = "ChatCell"
        
        static let partnerChatCell = "partner_chat_cell"
        static let partnerChatCellXibName = "PartnerMessageCell"
        
        static let textMessageCell = "text_message_cell"
        static let textMessageCellXibName = "TextMessageCell"
        
        static let imageMessageCell = "image_message_cell"
        static let imageMessageCellXibName = "ImageMessageCell"
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
        static let deviceID = "device_id"
    }
    
    struct VCID {
        static let login = "login"
        static let register = "register"
        static let home = "home"
        static let newMessage = "new_message"
        static let chatlog = "chatlog"
        static let zoomVC = "zoom_image"
        static let profileVC = "profile"
    }
    
    struct Color {
        static let blue = "Blue"
        static let darkBlue = "DarkBlue"
        static let green = "Green"
        static let white = "White"
        static let darkGray = "DarkGray"
        static let lightGray = "LightGray"
        static let lightBlue = "LightBlue"
    }
}
