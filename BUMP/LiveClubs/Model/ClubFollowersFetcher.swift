//
//  ClubFollowersFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 10/24/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol ClubFollowersFetcherDelegate : class {
    func clubFollowersUpdated(circleID : String, followerIDArray : [String])
}

class ClubFollowersFetcher {
    
    var db = Firestore.firestore()
    
    var listener : ListenerRegistration?
    
    weak var delegate : ClubFollowersFetcherDelegate?
    
    var circleID : String
    init(circleID : String) {
        self.circleID = circleID
    }
    
    func shutDown() {
        delegate = nil
        if let listenr = self.listener {
            listenr.remove()
        }
    }
    
    
    
    func startMonitor() {
        
        db.collection("LaunchCircles").document(circleID).collection("Followers").addSnapshotListener { (snap, err) in
            guard let docs = snap?.documents else { return }
            
            let followerIDArray = docs.map({$0.documentID})
            
            self.delegate?.clubFollowersUpdated(circleID: self.circleID, followerIDArray: followerIDArray)
        }
        
    }
    
    
}
