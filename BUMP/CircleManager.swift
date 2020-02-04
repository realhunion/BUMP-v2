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
    
    func presentCircleInfo(circleID : String, circleName : String, circleEmoji : String, circleDescription : String, memberArray : [LaunchMember]) {
        
        DispatchQueue.main.async {
            let vc = CircleInfoTVC(style: .grouped)
            vc.circleID = circleID
            vc.circleName = circleName
            vc.circleEmoji = circleEmoji
            vc.circleDescription = circleDescription
            vc.circleMemberArray = memberArray
            vc.title = circleName
            
            
            if #available(iOS 13.0, *) {
                let nvc = UINavigationController(rootViewController: vc)
                nvc.navigationBar.prefersLargeTitles = true
                vc.modalPresentationStyle = .pageSheet
                vc.modalPresentationCapturesStatusBarAppearance = true

                UIApplication.topViewController()?.present(nvc, animated: true, completion: nil)
            } else {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func enterCircle(chatID : String, firstMsg : String, circleID : String, circleName : String, circleEmoji : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        DispatchQueue.main.async {
            
            let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
            chatVC.chatID = chatID
            chatVC.circleName = circleName
            chatVC.circleID = circleID
            chatVC.chatName = firstMsg
            chatVC.circleEmoji = circleEmoji
            
            chatVC.hidesBottomBarWhenPushed = true
            
            chatVC.modalPresentationCapturesStatusBarAppearance = true
            
            (UIApplication.shared.delegate as! AppDelegate).bump?.homeTabBarVC.selectedIndex = 0
            

            UIApplication.topViewController()?.dismiss(animated: true)
            UIApplication.topViewController()?.navigationController?.pushViewController(chatVC, animated: true)
            
        }
    }
    
    func launchCircle(circleID : String, circleName : String, circleEmoji : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        UserDefaultsManager.shared.tappedLaunchCircle(circleID: circleID) //track

        DispatchQueue.main.async {
            
            let chatID = "\(Date().millisecondsSince1970)"
            
            let chatVC = LaunchChatVC(collectionViewLayout: UICollectionViewFlowLayout())
            chatVC.chatID = chatID
            chatVC.circleID = circleID
            chatVC.circleName = circleName
            chatVC.chatName = circleEmoji
            chatVC.circleEmoji = circleEmoji
            
            let transitionDelegate = SPStorkTransitioningDelegate()
            transitionDelegate.showIndicator = false
            transitionDelegate.translateForDismiss = 100

            chatVC.transitioningDelegate = transitionDelegate
            chatVC.modalPresentationStyle = .custom
            chatVC.modalPresentationCapturesStatusBarAppearance = true
            
            UIApplication.topViewController()?.dismiss(animated: true)
            UIApplication.topViewController()?.present(chatVC, animated: true) { }
            
            
        }
        
    }
    
    
    
    
    // MARK: - Tool Checks
    
    func isLaunchedLast24h(timeLaunched : Date) -> Bool {
        if let diff = Calendar.current.dateComponents([.hour], from: timeLaunched, to: Date()).hour, diff < 24 {
            return true
        } else {
            return false
        }
    }
    
    func presentNotificationExpired(circleID : String, circleName : String, circleEmoji : String) {
        let alert = UIAlertController(title: "Wait, what happend?", message: "Sorry, chats expire after 24h. But you can start another one 🤙", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let relaunchAction = UIAlertAction(title: "Launch", style: .default) { (act) in
            CircleManager.shared.launchCircle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        }
        alert.addAction(okAction)
        alert.addAction(relaunchAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Updating Feed User
    
    func updateFeedLastSeen(chatID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        //FIX: What if date and server timestmap dont line up. time zone diff.
        let payload = ["lastSeen":Timestamp(date: Date()), "unreadMsgs": 0] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
        
    }
    
    func updateFeedIsFollowing(chatID : String, isFollowing : Bool) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["isFollowing": isFollowing] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
}
