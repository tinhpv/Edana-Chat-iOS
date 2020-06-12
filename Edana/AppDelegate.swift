//
//  AppDelegate.swift
//  Edana
//
//  Created by TinhPV on 5/28/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var DEVICE_ID = String()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        Messaging.messaging().delegate = self
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        // REGISTER FOR NOTIFICATION
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // ADD ACTIONS TO NOTIFICATIONS
        let viewAction = UNNotificationAction(identifier: "view", title: "View", options: UNNotificationActionOptions.foreground)
        let notifCategory = UNNotificationCategory.init(identifier: "image_category", actions: [viewAction], intentIdentifiers: [], options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([notifCategory])
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //let application = UIApplication.shared
        let userInfo = response.notification.request.content.userInfo
        let senderID = userInfo["senderID"] as? String
        
        let sceneDelegate = UIApplication.shared.openSessions.first?.scene?.delegate as! SceneDelegate
        let newWindow = sceneDelegate.window

        if response.actionIdentifier == "view" {
            if senderID != nil {
                FirebaseService.getUserInfo(with: senderID!) { (user) in
                    if let user = user {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let homeVC = storyboard.instantiateViewController(identifier: Constant.VCID.home) as! HomeViewController
                        let chatlogVC = storyboard.instantiateViewController(identifier: Constant.VCID.chatlog) as! ChatLogViewController
                        chatlogVC.toUser = user
                        
//                        let navigationController = UINavigationController(rootViewController: homeVC)
                        let navigationController = UINavigationController()
                        navigationController.setViewControllers([homeVC, chatlogVC], animated: true)
                        newWindow?.rootViewController = navigationController
                        newWindow?.makeKeyAndVisible()
                    }
                } // end get info of user
            } // end unwrapping
        } // end response
    }
    
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        AppDelegate.DEVICE_ID = fcmToken
    }
    
    
}
