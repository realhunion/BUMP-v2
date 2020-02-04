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
        
        self.registerNotificationCategories()
        
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
    func registerNotificationCategories() {
        let followAction = UNNotificationAction(identifier: "followAction", title: "Follow Chat", options: UNNotificationActionOptions.foreground)
        let silenceAction = UNNotificationAction(identifier: "silenceAction", title: "Silence for 1 hour", options: UNNotificationActionOptions.foreground)
        let contentAddedCategory = UNNotificationCategory(identifier: "launchNotif", actions: [followAction, silenceAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([contentAddedCategory])
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
            print("goog follow")
            CircleFollower.shared.followCircle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
            return
        }
        if response.actionIdentifier == "silenceAction" {
            print("goog silence")
            SilenceManager.shared.silenceFor(numHours: 1)
            completionHandler()
            return
        }
        
        guard let timeLaunchedDouble = Double(timeLaunched) else { completionHandler(); return }
        let timeLaunchedDate = Date(timeIntervalSince1970: (timeLaunchedDouble / 1000.0))
        guard CircleManager.shared.isLaunchedLast24h(timeLaunched: timeLaunchedDate) else {
            CircleManager.shared.presentNotificationExpired(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
            completionHandler(); return }
        
    
        CircleManager.shared.enterCircle(chatID: chatID, firstMsg: firstMsgText, circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        
        completionHandler()
        return
        
    }
    
    
    
}

