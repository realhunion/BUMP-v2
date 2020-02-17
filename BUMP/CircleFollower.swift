//
//  CircleFollower.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

class CircleFollower {
    
    var db = Firestore.firestore()
    
    static let shared = CircleFollower()
    
    
    func followCircle(circleID : String, circleName : String, circleEmoji : String, notifsOn : Bool? = true) {
        
        NotificationManager.shared.isEnabled { (isEnabled) in
            guard isEnabled else { return }
            
            
            guard let myUID = Auth.auth().currentUser?.uid else { return }
            guard let myUsername = Auth.auth().currentUser?.displayName else { return }
            
            let batch = self.db.batch()
            let circleRef = self.db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID)
            batch.setData(["userName":myUsername, "notificationsOn":(notifsOn ?? true)], forDocument: circleRef)
            
            let profileRef = self.db.collection("User-Profile").document(myUID).collection("Following").document(circleID)
            batch.setData(["circleName":circleName, "circleEmoji":circleEmoji], forDocument: profileRef)
            
            
            batch.commit() { err in }
                
            
            
            //MANUALLY CHANGE DATASOURCE FOR LAUNCHTVC  (no listeners used)
            //FIX: FUTURE
            
            DispatchQueue.main.async {
                guard var circArray = (UIApplication.shared.delegate as! AppDelegate).bump?.homeTabBarVC.launchVC.circleArray else { return }
                if let circ = circArray.first(where: {$0.circleID == circleID}) {
                    circ.memberArray.removeAll(where: {$0.userID == myUID})
                    circ.memberArray.append(LaunchMember(userID: myUID, notifsOn: notifsOn ?? true))
                    circArray.removeAll(where: {$0.circleID == circleID})
                    circArray.append(circ)
                }
                (UIApplication.shared.delegate as! AppDelegate).bump?.homeTabBarVC.launchVC.allCirclesFetched(launchCircleArray: circArray)
            }
            
            
            
        }
        
    }
    
    func unFollowCircle(circleID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let batch = db.batch()
        let circleRef = self.db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID)
        batch.deleteDocument(circleRef)
        
        let profileRef = self.db.collection("User-Profile").document(myUID).collection("Following").document(circleID)
        batch.deleteDocument(profileRef)
        
        
        batch.commit() { err in }
        
        
        //MANUALLY CHANGE DATASOURCE FOR LAUNCHTVC  (no listeners used)
        //FIX: FUTURE
        
        DispatchQueue.main.async {
            guard var circArray = (UIApplication.shared.delegate as! AppDelegate).bump?.homeTabBarVC.launchVC.circleArray else { return }
            if let circ = circArray.first(where: {$0.circleID == circleID}) {
                circ.memberArray.removeAll(where: {$0.userID == myUID})
                circArray.removeAll(where: {$0.circleID == circleID})
                circArray.append(circ)
            }
            (UIApplication.shared.delegate as! AppDelegate).bump?.homeTabBarVC.launchVC.allCirclesFetched(launchCircleArray: circArray)
            
        }
        
    }
    
    
    
    
}
