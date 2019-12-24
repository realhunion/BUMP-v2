//
//  CircleManager.swift
//  BUMP
//
//  Created by Hunain Ali on 10/23/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase
import SPStorkController


class CircleManager {
    
    static let shared = CircleManager()
    
    var db = Firestore.firestore()
    var ref = Database.database().reference()
    
    var chatVC : ChatVC?
    
    deinit {
        print("Circle Manager is de init")
    }
    
    func shutDown() {
        self.chatVC?.shutDown()
        self.chatVC = nil
    }
    
    
    
    
    // MARK: Entering Circles
    
    func enterCircle(chatID : String, chatName : String, circleID : String, circleName : String) {
        
        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.chatID = chatID
        chatVC.circleName = circleName
        chatVC.circleID = circleID
        chatVC.chatName = chatName
        chatVC.tabBarItem.tag = 0
        
        
        UIApplication.topViewController()?.dismiss(animated: false, completion: nil)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.showIndicator = false
        transitionDelegate.translateForDismiss = 100
        
//        chatVC.transitioningDelegate = transitionDelegate
        chatVC.modalPresentationStyle = .pageSheet
        chatVC.modalPresentationCapturesStatusBarAppearance = true
        
//        UIApplication.topViewController()?.present(chatVC, animated: true) {
//            //
//        }
        
        chatVC.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    func launchCircle(circleID : String, circleName : String) {
        
//        let chatIDString = "\(Date().timeIntervalSince1970.bitPattern)"
        let chatID = "\(Date().timeIntervalSince1970.bitPattern)"
        let chatName = "🤙"
        
        let chatVC = LaunchChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.chatID = chatID
        chatVC.circleName = circleName
        chatVC.circleID = circleID
        chatVC.chatName = chatName
        chatVC.tabBarItem.tag = 0
        
        
//        UIApplication.topViewController()?.dismiss(animated: false, completion: nil)
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        transitionDelegate.showIndicator = false
//        transitionDelegate.translateForDismiss = 100
//        
//        chatVC.modalPresentationStyle = .pageSheet
//        chatVC.modalPresentationCapturesStatusBarAppearance = true
//        
//        chatVC.hidesBottomBarWhenPushed = true
//        UIApplication.topViewController()?.navigationController?.pushViewController(chatVC, animated: true)
        
        
        UIApplication.topViewController()?.dismiss(animated: false, completion: nil)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.showIndicator = false
        transitionDelegate.translateForDismiss = 100

        chatVC.transitioningDelegate = transitionDelegate
        chatVC.modalPresentationStyle = .custom
        chatVC.modalPresentationCapturesStatusBarAppearance = true

        UIApplication.topViewController()?.present(chatVC, animated: true) {
            //
        }
        
        
        
    }
    
    
    
    
    // MARK: - Updating Feed User
    
    func updateFeedLastSeen(chatID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        //FIX: What if date and server timestmap dont line up. time zone diff.
        let payload = ["lastSeen":Timestamp(date: Date())] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
        print("tesser 1 set")
        
    }
    
    func updateFeedIsFollowing(chatID : String, isFollowing : Bool) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["isFollowing": isFollowing] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
}
