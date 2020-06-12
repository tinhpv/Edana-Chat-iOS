//
//  SceneDelegate.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        configInitialViewController()
    }
    
    func configInitialViewController() {
        let defaults = UserDefaults.standard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let _ = Auth.auth().currentUser,
            let userData = defaults.object(forKey: Constant.UserDefaults.currentUser) as? Data,
            let user = try? JSONDecoder().decode(User.self, from: userData) {
            User.setCurrent(user, writeToUserDefaults: true)
            
            let homeVC = storyboard.instantiateViewController(identifier: Constant.VCID.home) as! HomeViewController
            let navigationController = UINavigationController(rootViewController: homeVC)
            self.window?.rootViewController = navigationController
        } else {
            let loginVC = storyboard.instantiateViewController(identifier: Constant.VCID.login) as! LoginViewController
            self.window?.rootViewController = loginVC
        }
    
        self.window?.makeKeyAndVisible()
    }

}

