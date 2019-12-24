//
//  ClubCell+Follow.swift
//  BUMP
//
//  Created by Hunain Ali on 11/17/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Firebase

extension ClubCell {
    
    
    @objc func tappedFollowButton(_ sender: UIButton) {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        NotificationManager.shared.isEnabled { (isEnabled) in
            guard isEnabled else { return }
            
            DispatchQueue.main.async {
                
                guard let circleID = self.clubTitleLabel.text else { return }
                guard let myUID = Auth.auth().currentUser?.uid else { return }
                
                sender.isEnabled = false
                
                let db = Firestore.firestore()
                let batch = db.batch()
                
                if sender.titleLabel?.text == "Follow" {
                    let clubRef = db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID)
                    batch.setData([:], forDocument: clubRef)
                    
                    let profileRef = db.collection("User-Profile").document(myUID).collection("Following").document(circleID)
                    batch.setData([:], forDocument: profileRef)
                }
                else {
                    let clubRef = db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID)
                    batch.deleteDocument(clubRef)
                    
                    let profileRef = db.collection("User-Profile").document(myUID).collection("Following").document(circleID)
                    batch.deleteDocument(profileRef)
                }
                
                batch.commit() { err in
                    sender.isEnabled = true
                }
            }
        }
        
    }
    
    
    
}
