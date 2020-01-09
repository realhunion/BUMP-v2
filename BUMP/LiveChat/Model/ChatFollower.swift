//
//  ChatFollower.swift
//  BUMP
//
//  Created by Hunain Ali on 1/7/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol ChatFollowerDelegate : class {
    func chatFollowUpdated(isFollowing : Bool)
}

class ChatFollower {
    
    var db = Firestore.firestore()
    
    var followListener : ListenerRegistration?
    
    var delegate : ChatFollowerDelegate?
    
    //
    
    var isFollowing : Bool?
    
    var chatID : String
    init(chatID : String) {
        self.chatID = chatID
    }
    
    func shutDown() {
        if let listenr = self.followListener {
            listenr.remove()
        }
    }
    
    func monitorMyFollow() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        followListener = db.collection("Feed").document(chatID).collection("Users").document(myUID).addSnapshotListener({ (snap, err) in
            guard let data = snap?.data() else { return }
            
            if let follow = data["isFollowing"] as? Bool {
                
                if self.isFollowing != follow {
                    print("motor")
                    self.isFollowing = follow
                    self.delegate?.chatFollowUpdated(isFollowing: follow)
                }
                
            }
        })
        
    }
    
    
    //MARK : - Actions
    
    func followChat() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["isFollowing" : true] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
    func unFollowChat() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let payload = ["isFollowing" : false] as [String:Any]
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).setData(payload, merge: true)
        
    }
    
    
    
}
