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
        
        self.configureMyFirebase()
        Messaging.messaging().delegate = self
        
//        self.topicNotifs()
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.bump = BUMP()
        window?.rootViewController = self.bump?.homeTabBarVC
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.bump?.appWillResignActive()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.bump?.appWillEnterForeground()
        
    }
    
    
    // MARK:- Notifications
    
    
    
    
    
    
    
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
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
       
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("**** New Token Generated***\(fcmToken)***")
        self.bump?.updateUserBaseFCMToken(fcmToken: fcmToken)
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let chatID = response.notification.request.content.userInfo["chatID"] as? String,
            let firstMsg = response.notification.request.content.userInfo["firstMsg"] as? String,
            let circleID = response.notification.request.content.userInfo["circleID"] as? String,
            let circleName = response.notification.request.content.userInfo["circleName"] as? String,
            let circleEmoji = response.notification.request.content.userInfo["circleEmoji"] as? String else { return }
        
        CircleManager.shared.enterCircle(chatID: chatID, firstMsg: firstMsg, circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        
        //Tweak: start at 0, when tap on notification.
//        let circManager = CircleManager.shared
//        self.bump?.homeTabBarVC.selectedIndex = 0
//        circManager.enterCircle(chatID: chatID, chatName: "Chat Name", circleID: "Free Food", circleName: "Free Food")
        
    }
    
    
    
}

