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
    
    
    func followCircle(circleID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let batch = db.batch()
        let circleRef = self.db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID)
        batch.setData([:], forDocument: circleRef)
        
        let profileRef = self.db.collection("User-Profile").document(myUID).collection("Following").document(circleID)
        batch.setData([:], forDocument: profileRef)
        
        
        batch.commit() { err in
            //
        }
        
    }
    
    func unFollowCircle(circleID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let batch = db.batch()
        let circleRef = self.db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID)
        batch.deleteDocument(circleRef)
        
        let profileRef = self.db.collection("User-Profile").document(myUID).collection("Following").document(circleID)
        batch.deleteDocument(profileRef)
        
        
        batch.commit() { err in
            //
        }
        
    }
    
    
    
    
    
}
