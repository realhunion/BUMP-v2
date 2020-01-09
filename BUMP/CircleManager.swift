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
    
    func enterCircle(chatID : String, firstMsg : String, circleID : String, circleName : String, circleEmoji : String) {
        
        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.chatID = chatID
        chatVC.circleName = "\(circleEmoji) · \(circleName) "
        chatVC.circleID = circleID
        chatVC.chatName = firstMsg
        chatVC.circleEmoji = circleEmoji
        
        
        UIApplication.topViewController()?.dismiss(animated: false, completion: nil)
        chatVC.modalPresentationCapturesStatusBarAppearance = true
        
        chatVC.hidesBottomBarWhenPushed = true
        
        UIApplication.topViewController()?.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    func launchCircle(circleID : String, circleName : String, circleEmoji : String) {
        
        
        let chatID = "\(Date().timeIntervalSince1970.bitPattern)"
        
        let chatVC = LaunchChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.chatID = chatID
        chatVC.circleID = circleID
        chatVC.circleName = circleName
        chatVC.chatName = circleEmoji
        chatVC.circleEmoji = circleEmoji
        
        
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
        
        
    }
    
    func updateFeedRead(chatID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["unreadMsgs": 0] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
    func updateFeedIsFollowing(chatID : String, isFollowing : Bool) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["isFollowing": isFollowing] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
}
