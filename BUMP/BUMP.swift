//
//  BUMP.swift
//  BUMP
//
//  Created by Hunain Ali on 10/23/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit

class BUMP {
    
    let db = Firestore.firestore()
    
    var homeTabBarVC : HomeTabBarVC
    init() {
        self.homeTabBarVC = HomeTabBarVC()
        
        let v = AllCirclesFetcher()
        v.fetchAllCircles()
    }
    
    
    
    func refreshControllers() {
        
        SwiftEntryKit.dismiss(.all, with: nil)
        homeTabBarVC.dismiss(animated: true, completion: nil)
        
        homeTabBarVC.hubVC.navigationController?.popToRootViewController(animated: false)
        homeTabBarVC.feedTVC.navigationController?.popToRootViewController(animated: false)
        homeTabBarVC.launchVC.navigationController?.popToRootViewController(animated: false)
    
        homeTabBarVC.launchVC.shutDown()
        homeTabBarVC.launchVC.setupLaunchFetcher()
        homeTabBarVC.launchVC.setupCategoriesFetcher()
        
        homeTabBarVC.feedTVC.shutDown()
        homeTabBarVC.feedTVC.setupFeedFetcher()
        
        AnnouncementsManager.shared.shutDown()
        AnnouncementsManager.shared.startMonitors()
        
        
        homeTabBarVC.selectedIndex = 1
        homeTabBarVC.currentIndex = 1
        
    }
    
    func logOut() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User-Base").document(myUID).updateData([
            "fcmToken": FieldValue.delete(),
        ]) { err in
            guard err == nil else { return }
        }
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.refreshControllers()
        UserDefaultsManager.shared.clearAllData()
    }
    
    func logIn() {
        
        if let token = Messaging.messaging().fcmToken {
            self.updateUserBaseFCMToken(fcmToken: token)
        }
        
        self.refreshControllers()
        
        LoginManager.shared.isLoggedIn()
        
    }
    
    
    func updateUserBaseFCMToken(fcmToken : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let payload = [ "fcmToken": fcmToken, "typePhone": 1] as [String : Any] //1 is iPhone, 2 is Android
        self.db.collection("User-Base").document(myUID).setData(payload, merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    

    
    func appDidEnterBackground() {
        SwiftEntryKit.dismiss(.all)
        UIApplication.topViewController()?.dismiss(animated: false, completion: nil)
        UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: false)
    }
    
    func appDidEnterForeground() {
        UpdateManager.shared.checkForUpdates()
        
//        AnnouncementsManager.shared.shutDown()
//        AnnouncementsManager.shared.startMonitors()
        //FIX: when to start this
//        AnnouncementsManager.shared.fetchAllAnnouncements()
//        AnnouncementsManager.shared.startMonitors()
//        self.homeTabBarVC.launchVC.refreshLaunchFetcher()
        
        
    }
    
    func appWillEnterForeground() {
//        self.homeTabBarVC.feedTVC.feedFetcher?.refreshFeedChats()
        
//        let v = AllCirclesFetcher()
//        v.fetchAllCircles()
    }
    
    
    
}
