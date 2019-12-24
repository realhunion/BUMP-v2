//
//  UserProfileFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 11/6/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

struct UserProfile {
    var userID : String
    var userName : String
    var userHandle : String
    var userImage : String
    var userDescription : String
}

protocol UserProfileFetcherDelegate: class {
    func userProfileUpdated(userID: String, userProfile : UserProfile)
}

class UserProfileFetcher {
    
    var db = Firestore.firestore()
    
    weak var delegate: UserProfileFetcherDelegate?
    
    var listener : ListenerRegistration?
    
    
    
    var userID : String
    init(userID : String) {
        self.userID = userID
    }
    
    func shutDown() {
        self.removeListener()
        self.delegate = nil
    }
    
    
    
    
    func monitorUserProfile() {
        
        print("cooooo 1 \(userID)")
        
        listener = db.collection("User-Profile").document(userID).addSnapshotListener { (snap, err) in
            guard let data = snap?.data() else { return }
            
            if let userName = data["userName"] as? String,
                let userHandle = data["userHandle"] as? String,
                let userDescription = data["userDescription"] as? String
            {
                
                let userImage = "User-Profile-Images/\(self.userID).jpg"
                
                let uProfile = UserProfile(userID: self.userID, userName: userName, userHandle: userHandle, userImage: userImage, userDescription: userDescription)
                
                self.delegate?.userProfileUpdated(userID: self.userID, userProfile: uProfile)
                
            }
        }
    }
    
    func removeListener() {
        if let listenr = listener {
            listenr.remove()
        }
    }
    
    
    
    
    
    func getUserProfile() {
        
        db.collection("User-Profile").document(userID).getDocument { (snap, err) in
            
            guard let data = snap?.data() else { return }
            
            if let userName = data["userName"] as? String,
                let userHandle = data["userHandle"] as? String,
                let userDescription = data["userDescription"] as? String
            {
                
                let userImage = "User-Profile-Images/\(self.userID).jpg"
                
                let uProfile = UserProfile(userID: self.userID, userName: userName, userHandle: userHandle, userImage: userImage, userDescription: userDescription)
                
                self.delegate?.userProfileUpdated(userID: self.userID, userProfile: uProfile)
                
            }
        }
    }
    
    
    
    
    
    
    
}
