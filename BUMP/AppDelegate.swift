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
    
    
    
    
    func topicNotifs() {
    
        return
        
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        var clubArray = [String]()
        var clubDataDict = [String:[String:Any]]()
        db.collection("User-Profile").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { return }
            clubArray = docs.map({$0.documentID})
            for doc in docs {
                print("posty")
                clubDataDict[doc.documentID] = doc.data()
            }
            
            dispatchGroup.leave()
        }
        
//        return
//            print("posty1")


        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            
            var clubFollowersDict = [String:[String]]()
            print("i wish -1.555 \(clubArray.count)")
            let batch = self.db.batch()

            let dispatchGroup1 = DispatchGroup()

            for club in clubArray {
                print("i wish -1.55 \(club)")
                dispatchGroup1.enter()
                self.db.collection("User-Profile").document(club).collection("Following").getDocuments { (snap, err) in
                    guard let docs = snap?.documents else { return }

                    print("i wish -1 \(docs.map({$0.documentID}))")

                    print("cooleded 1")
                    for doc in docs {
//                        let ref = self.db.collection("User-ProfileV1").document(club).collection("Following").document(doc.documentID)
//                        batch.setData([:], forDocument: ref)
//                        let ref0 = self.db.collection("User-ProfileV1").document(club)
//                        batch.setData(clubDataDict[club] ?? [:], forDocument: ref0)
                        self.db.collection("User-Profile").document(club).collection("Following").document(doc.documentID).delete()

                    }
                    dispatchGroup1.leave()

                }

            }

            dispatchGroup1.notify(queue: DispatchQueue.main, execute: {

                batch.commit()

            })
            
//            let batch = self.db.batch()
//            for club in clubArray {
//                let ref = self.db.collection("User-Profile").document(club).collection("Following").document(doc.documentID)
//                batch.deleteDocument(ref)
//            }
            
            print("i wish 0 \(clubArray.count)")
        })
        
        
//        let dispatchGroup = DispatchGroup()
        
//        dispatchGroup.enter()
//        var clubArray = [String]()
//        db.collection("User-Profile").getDocuments { (snap, err) in
//            guard let docs = snap?.documents else { return }
//
//            for doc in docs {
//
//                self.db.collection("User-Profile").document(doc.documentID).collection("Following").getDocuments { (snap, err) in
//                    guard let docs2 = snap?.documents else { return }
//
//                    for doc2 in docs2 {
//                        self.db.collection("User-Profile").document(doc.documentID).collection("Following").document(doc2.documentID).delete()
//                    }
//
//                }
//
//            }
//
//        }
        
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
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
       
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("**** New Token Generated***\(fcmToken)***")
        self.bump?.updateUserBaseFCMToken(fcmToken: fcmToken)
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("okr \(response.notification.request.content.userInfo)")
        
        guard let chatID = response.notification.request.content.userInfo["chatID"] as? String else { return }
        
        //Tweak: start at 0, when tap on notification.
        let circManager = CircleManager.shared
        self.bump?.homeTabBarVC.selectedIndex = 0
        circManager.enterCircle(chatID: chatID, chatName: "Chat Name", circleID: "Free Food", circleName: "Free Food")
        
    }
    
    
    
}

