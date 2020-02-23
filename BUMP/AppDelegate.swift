//
//  AppDelegate.swift
//  BUMP
//
//  Created by Hunain Ali on 10/20/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import SwiftEntryKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var db : Firestore!
    var bump : BUMP?
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.registerForRemoteNotifications()
        self.registerForPushNotifications()
        
        self.registerNotificationActionButtons()
        
        self.configureMyFirebase()
        Messaging.messaging().delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.bump = BUMP()
        window?.rootViewController = self.bump?.homeTabBarVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.bump?.appDidEnterBackground()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.bump?.appDidEnterForeground()
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("wef 000")
        self.bump?.appWillEnterForeground()
    }
    
    
    
    
    
    
    // MARK: - Configure Firebase
    
    func configureMyFirebase() {
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        self.db = Firestore.firestore()
        Firestore.firestore().settings = settings
        Database.database().isPersistenceEnabled = false
    }


}





extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate {
    
    //Actionable Push Notification
    func registerNotificationActionButtons() {
        
        let followAction = UNNotificationAction(identifier: "followAction", title: "Enable Notifs for Chat", options: UNNotificationActionOptions.init())
        let silenceAction = UNNotificationAction(identifier: "silenceAction", title: "Silence for 1 hour", options: UNNotificationActionOptions.init())
        
        let launchNotifCategory = UNNotificationCategory(identifier: "launchNotif", actions: [followAction, silenceAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        
        
        let unFollowAction = UNNotificationAction(identifier: "unFollowAction", title: "Disable Notifs for Chat", options: UNNotificationActionOptions.init())
        
        let replyNotifCategory = UNNotificationCategory(identifier: "replyNotif", actions: [unFollowAction, silenceAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([launchNotifCategory, replyNotifCategory])
    }
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("**** New Token Generated***\(fcmToken)***")
        self.bump?.updateUserBaseFCMToken(fcmToken: fcmToken)
        
    }
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let chatID = response.notification.request.content.userInfo["chatID"] as? String,
            let circleID = response.notification.request.content.userInfo["circleID"] as? String,
            let circleName = response.notification.request.content.userInfo["circleName"] as? String,
            let circleEmoji = response.notification.request.content.userInfo["circleEmoji"] as? String,
            let firstMsgText = response.notification.request.content.userInfo["firstMsgText"] as? String,
            let timeLaunched = response.notification.request.content.userInfo["timeLaunched"] as? String else { completionHandler(); return }
        
        
        if response.actionIdentifier == "followAction" {
            
            guard let myUID = Auth.auth().currentUser?.uid else { completionHandler(); return }
            let payload = ["isFollowing" : true, "lastSeen":Timestamp(date: Date()), "unreadMsgs": 0] as [String:Any]
            db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true) { (err) in
                completionHandler()
                return
            }
            
        }
        else if response.actionIdentifier == "unFollowAction" {
            
            guard let myUID = Auth.auth().currentUser?.uid else { completionHandler(); return }
            let payload = ["isFollowing" : false, "lastSeen":Timestamp(date: Date()), "unreadMsgs": 0] as [String:Any]
            db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true) { (err) in
                completionHandler()
                return
            }
            
        }
        else if response.actionIdentifier == "silenceAction" {
            
            guard let myUID = Auth.auth().currentUser?.uid else { completionHandler(); return }
            let t = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            var data : [String : Any] = [:]
            data["silenceUntil"] = t
            self.db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
                completionHandler()
                return
            }
            
        }
        else {
            
            guard let timeLaunchedDouble = Double(timeLaunched) else { completionHandler(); return }
            let timeLaunchedDate = Date(timeIntervalSince1970: (timeLaunchedDouble / 1000.0))
            
            guard LimitManager.shared.isChatActive(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji, timeLaunched: timeLaunchedDate) else {
                completionHandler(); return }
            
            CircleManager.shared.enterCircle(chatID: chatID, firstMsg: firstMsgText, circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
            
            completionHandler()
            return
            
        }
    }
    
    
    
}

