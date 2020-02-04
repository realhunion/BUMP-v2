//
//  CircleInfoFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 1/25/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

struct CircleMember {
    var userID : String
    var isFollowing : Bool?
}

protocol CircleMembersFetcherDelegate : class {
    func circleMembersFetched(profileArray : [UserProfile])
}

class CircleMembersFetcher {
    
    var db = Firestore.firestore()
    
    var delegate : CircleMembersFetcherDelegate?
    
    var fetchedMembersDict : [String:Bool] = [:] //userID : fetched or not
    var memberProfileArray : [UserProfile] = []
    var memberNotifsOnDict : [String:Bool] = [:]
    
    var circleID : String
    init(circleID : String) {
        self.circleID = circleID
    }
    
    
    
    func fetchAllCircleMembers() {
        
        db.collection("LaunchCircles").document(self.circleID).collection("Followers").getDocuments { (snap, err) in
            
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                let userID = doc.documentID
                self.fetchedMembersDict[userID] = false
            }
            
            for doc in docs {
                let userID = doc.documentID
                self.fetchMemberProfile(userID: userID)
                
            }
            
        }
        
    }
    
    func fetchCircleMembers(userIDArray : [String]) {
        
        for userID in userIDArray {
            self.fetchedMembersDict[userID] = false
        }
        
        for userID in userIDArray {
            self.fetchMemberProfile(userID: userID)
        }
        
        
        
    }
    
    func fetchMemberProfile(userID : String) {
        
        db.collection("User-Profile").document(userID).getDocument { (snap, err) in
            guard let doc = snap else { return }
            
            if let userName = doc.data()?["userName"] as? String, let userHandle = doc.data()?["userHandle"] as? String {
                let userID = doc.documentID
                let userImage = "User-Profile-Images/\(userID).jpg"
                
                let uProfile = UserProfile(userID: userID, userName: userName, userHandle: userHandle, userImage: userImage, userDescription: "")
                //FIX:
                
                self.fetchedMembersDict[userID] = true
                self.memberProfileArray.append(uProfile)
                
                self.triggerUpdate()
            }
            
            
        }

    }
    
    
    
    
    
    //MARK: - Trigger Update
    
    func triggerUpdate() {
        //FIX: Make sager dangerous
        guard !self.fetchedMembersDict.values.contains(where: {$0 == false}) else { return }
        
        self.delegate?.circleMembersFetched(profileArray: self.memberProfileArray)
        
    }
    
}
