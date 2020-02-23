//
//  ChatFollower.swift
//  BUMP
//
//  Created by Hunain Ali on 1/16/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase


class ChatFollower {
    
    
    var db = Firestore.firestore()
    
    static let shared = ChatFollower()
    
    
    //MARK : - Actions
    
    func followChat(chatID : String) {
        
        NotificationManager.shared.isEnabled { (isEnabled) in
            guard isEnabled else { return }
            
            guard let myUID = Auth.auth().currentUser?.uid else { return }
            
            let payload = ["isFollowing" : true, "lastSeen":Timestamp(date: Date()), "unreadMsgs": 0] as [String:Any]
            
            self.db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
            
        }
    }
    
    func unFollowChat(chatID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["isFollowing" : false, "lastSeen":Timestamp(date: Date()), "unreadMsgs": 0] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
    
    
    
    
    
    
}
