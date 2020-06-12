//
//  User.swift
//  Edana
//
//  Created by TinhPV on 5/30/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: String
    let name: String
    let email: String
    let profileImageUrl: URL?
    let deviceID: String
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }

        return currentUser
    }
    
    static func setCurrent(_ user: User) {
        _current = user
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: Constant.UserDefaults.currentUser)
            }
        }
        
        _current = user
    }
}
