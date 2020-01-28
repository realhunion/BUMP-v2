//
//  CircleInfoFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 1/25/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase


protocol CircleMembersFetcherDelegate : class {
    func circleMembersFetched(circleMembers : [UserProfile])
}

class CircleMembersFetcher {
    
    var db = Firestore.firestore()
    
    var delegate : CircleMembersFetcherDelegate?
    
    var fetchedMembersDict : [String:UserProfile?] = [:] //userID : UserProfile
    
    var circleID : String
    init(circleID : String) {
        self.circleID = circleID
    }
    
    
    
    func fetchCircleMembers() {
        
        db.collection("LaunchCircles").document(self.circleID).collection("Followers").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                let userID = doc.documentID
                self.fetchedMembersDict[userID] = nil
            }
            
            for doc in docs {
                let userID = doc.documentID
                self.fetchCircleMember(userID: userID)
            }
            
        }
        
    }
    
    func fetchCircleMember(userID : String) {
        
        db.collection("User-Profile").document(userID).getDocument { (snap, err) in
            guard let doc = snap else { return }
            
            if let userName = doc.data()?["userName"] as? String, let userHandle = doc.data()?["userHandle"] as? String {
                let userID = doc.documentID
                let userImage = "User-Profile-Images/\(userID).jpg"
                
                let uProfile = UserProfile(userID: userID, userName: userName, userHandle: userHandle, userImage: userImage, userDescription: "")
                self.fetchedMembersDict[userID] = uProfile
                
                self.triggerUpdate()
            }
            
            
        }

    }
    
    
    
    
    
    //MARK: - Trigger Update
    
    func triggerUpdate() {
        //FIX: Make sager dangerous
        guard !self.fetchedMembersDict.values.contains(where: {$0 == nil}) else { return }
        
        let memberArray = Array(self.fetchedMembersDict.values) as! [UserProfile]
        
        self.delegate?.circleMembersFetched(circleMembers: memberArray)
        
    }
    
}
