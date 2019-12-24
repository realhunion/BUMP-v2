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
        print("Beauty: \(Auth.auth().currentUser?.isEmailVerified)")
    }
    
    
    
    func refreshControllers() {
        
        SwiftEntryKit.dismiss(.all, with: nil)
        homeTabBarVC.dismiss(animated: true, completion: nil)
        
        homeTabBarVC.categoriesVC.navigationController?.popToRootViewController(animated: false)
    
        // scroll to top
        homeTabBarVC.categoriesVC.collectionView.scrollToTop(false)
        homeTabBarVC.campusClubsVC.collectionView.scrollToTop(false)
        
        homeTabBarVC.campusClubsVC.collectionView.reloadData()
        
        //FIX:
//        homeTabBarVC.feedVC.shutDown()
//        homeTabBarVC.feedVC.setupClubsFetcher()
        
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
    }
    
    func logIn() {
        
        if let token = Messaging.messaging().fcmToken {
            self.updateUserBaseFCMToken(fcmToken: token)
        }
        
        self.refreshControllers()
        
    }
    
    
    func updateUserBaseFCMToken(fcmToken : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let payload = [ "fcmToken": fcmToken, "typePhone": 1] as [String : Any] //1 is iPhone, 2 is Android
        self.db.collection("User-Base").document(myUID).setData(payload, merge: true) { err in
            print("poop 2 success : \(err == nil)")
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    
    func appWillEnterForeground() {
        
        homeTabBarVC.campusClubsVC.sortClubInfoArray()
        homeTabBarVC.campusClubsVC.collectionView.reloadData()
        
        //FIX:
//        homeTabBarVC.feedVC.sortClubInfoArray()
//        homeTabBarVC.feedVC.collectionView.reloadData()
        
    }
    
    func appWillResignActive() {
        
        SwiftEntryKit.dismiss(.all)
        UIApplication.topViewController()?.dismiss(animated: false, completion: nil)
        UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: false)
        
    }
    
    
    
}
