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
        
        
        let vc = CircleInfoTVC(style: .grouped)
        vc.circleID = circleID
        vc.circleName = circleName
        vc.circleEmoji = circleEmoji
        vc.circleDescription = circleDescription
        vc.circleMemberArray = memberArray
        vc.title = circleName
        
        DispatchQueue.main.async {
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
        
        
        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.chatID = chatID
        chatVC.circleName = circleName
        chatVC.circleID = circleID
        chatVC.chatName = firstMsg
        chatVC.circleEmoji = circleEmoji
        
        chatVC.hidesBottomBarWhenPushed = true
        
        (UIApplication.shared.delegate as! AppDelegate).bump?.homeTabBarVC.selectedIndex = 0
        
        DispatchQueue.main.async {
            
            UIApplication.topViewController()?.dismiss(animated: true)
            UIApplication.topViewController()?.navigationController?.pushViewController(chatVC, animated: true)
            
        }
    }
    
    func launchCircle(circleID : String, circleName : String, circleEmoji : String) {
        
        guard LimitManager.shared.canLaunchCircle() else { return }
        UserDefaultsManager.shared.tappedLaunchCircle(circleID: circleID) //track
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let chatID = "\(Date().millisecondsSince1970)"
        
        let chatVC = LaunchChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.chatID = chatID
        chatVC.circleID = circleID
        chatVC.circleName = circleName
        chatVC.chatName = circleEmoji
        chatVC.circleEmoji = circleEmoji
        
        chatVC.title = circleName
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.dismiss(animated: true)
            
            chatVC.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(chatVC, animated: true)
        }
        
    }
    
    
    
    
    // MARK: - Updating Feed User
    
    func updateFeedLastSeen(chatID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["lastSeen":Date(), "unreadMsgs": 0] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
        
    }
    
    func updateFeedIsFollowing(chatID : String, isFollowing : Bool) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["isFollowing": isFollowing] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
}
