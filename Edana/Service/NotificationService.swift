//
//  NotificationService.swift
//  Edana
//
//  Created by TinhPV on 6/12/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation

struct NotificationService {
    
    static func sendNotification(to deviceToken: String, senderName: String, textMsg: String?, imageUrl: String?) {
        
        var parameters: [String : AnyObject] = [:]
        if let textMsg = textMsg {
            parameters = [
                "to" : deviceToken,
                "notification" : [
                    "title" : senderName,
                    "body" : textMsg,
                    "badge" : 1,
                    "sound" : "default"
                    ],
                "data" : ["senderID" : User.current.id]
            ] as [String : AnyObject]
        } else {
            parameters = [
                "to" : deviceToken,
                "mutable_content" : true,
                "notification" : [
                    "title" : senderName,
                    "body" : "\(senderName) sent an image",
                    "badge" : 1,
                    "sound" : "default",
                    "click_action" : "image_category"
                ],
                "data" : ["urlImageString" : imageUrl!,
                          "senderID" : User.current.id]
            ] as [String : AnyObject]
        }
        
        
        buildSendRequest(parameters: parameters)
    }
    
    
    fileprivate static func buildSendRequest(parameters: [String : AnyObject]) {
        var request: URLRequest?
        request = URLRequest(url: URL(string: Constant.HTTPKey.fcmServerUrl)!)
        request!.httpMethod = "POST"
        request!.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request!.setValue("key=\(Constant.HTTPKey.serverKey)", forHTTPHeaderField: "Authorization")
        
        request?.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request!) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        print("Successfully sent")
                    default:
                        print("HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
                // there's something wrong
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
}
