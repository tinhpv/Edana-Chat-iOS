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
import UserNotificationsUI

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
        let viewAction = UNNotificationAction(identifier: "view", title: "View", options: .foreground)
        
        let replyAction = UNTextInputNotificationAction(identifier: "reply", title: "Reply message", options: UNNotificationActionOptions(rawValue: 0), textInputButtonTitle: "Send", textInputPlaceholder: "Message")

        
        let notifCategory = UNNotificationCategory.init(identifier: "image_category", actions: [viewAction, replyAction], intentIdentifiers: [], options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([notifCategory])
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //let application = UIApplication.shared
        let userInfo = notification.request.content.userInfo
        let senderID = userInfo["senderID"] as? String
        
        let sceneDelegate = UIApplication.shared.openSessions.first?.scene?.delegate as! SceneDelegate
        let newWindow = sceneDelegate.window
        
        var currentVC = newWindow?.rootViewController
        if (currentVC is UINavigationController){
            currentVC = (currentVC as! UINavigationController).visibleViewController
        } // end get visible view controller
        
        if (currentVC is ChatLogViewController){
            let chatlogVC = currentVC as! ChatLogViewController
            if chatlogVC.toUser?.id != senderID {
                completionHandler([.alert, .badge, .sound])
            }
        } else {
            completionHandler([.alert, .badge, .sound])
        } // end if current VC is chatlog
    
    }
    
    func delay(_ delay:Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //let application = UIApplication.shared
        let userInfo = response.notification.request.content.userInfo
        let senderID = userInfo["senderID"] as? String
        
        let sceneDelegate = UIApplication.shared.openSessions.first?.scene?.delegate as! SceneDelegate
        let newWindow = sceneDelegate.window

        
        
        if senderID != nil {
            if response.actionIdentifier == "reply" {
                
                var id = UIBackgroundTaskIdentifier.invalid
                id = UIApplication.shared.beginBackgroundTask {
                    UIApplication.shared.endBackgroundTask(id)
                }
                
                delay(0.1) {
                    if let textResponse =  response as? UNTextInputNotificationResponse {
                        let text = textResponse.userText
                        if (!text.isEmpty) {
                            FirebaseService.handleSaveTextMessage(content: text, fromID: User.current.id, toID: senderID!) { (error) in
                                if let _ = error {
                                    // TODO: handle error
                                    
                                } else {
                                    // SUCCESS
                                }
                            }
                        } // end if empty text
                    }
                } // end delay
                
            
                completionHandler()
            } else {
                FirebaseService.getUserInfo(with: senderID!) { (user) in
                    if let user = user {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let homeVC = storyboard.instantiateViewController(identifier: Constant.VCID.home) as! HomeViewController
                        let chatlogVC = storyboard.instantiateViewController(identifier: Constant.VCID.chatlog) as! ChatLogViewController
                        chatlogVC.toUser = user
                        let navigationController = UINavigationController()
                        navigationController.setViewControllers([homeVC, chatlogVC], animated: true)
                        newWindow?.rootViewController = navigationController
                        newWindow?.makeKeyAndVisible()
                    }
                } // end get info of user
            }
        } // end unwrapping
        
    }
    
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        AppDelegate.DEVICE_ID = fcmToken
    }
    
}


extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom(vc: navigationController.visibleViewController!)
        } else if vc.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)
            } else {
                return vc;
            }
        } // end if
    }
}
