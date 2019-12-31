//
//  LaunchCircleFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 10/24/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol LaunchCircleFetcherDelegate : class {
    func launchCircleUpdated(circleID : String, launchCircle : LaunchCircle)
}

class LaunchCircleFetcher {
    
    var db = Firestore.firestore()
    
    var myFollowListener : ListenerRegistration?
    
    weak var delegate : LaunchCircleFetcherDelegate?
    
    
    var followerIDArray : [String]? = nil
    var myFollow : Bool? = nil
    
    var circleID : String
    var circleName : String
    var circleEmoji : String
    init(circleID : String, circleName : String, circleEmoji : String) {
        self.circleID = circleID
        self.circleName = circleName
        self.circleEmoji = circleEmoji
    }
    
    func shutDown() {
        delegate = nil
        if let listenr = self.myFollowListener {
            listenr.remove()
        }
    }
    
    
    //MARK: - MAIN
    
    func startMonitors() {
        self.fetchFollowers()
        self.monitorMyFollow()
    }
    
    func triggerUpdate() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        guard let myFollow = self.myFollow else { return }
        guard let followerIDArray = self.followerIDArray else { return }
        
        let launchCircle = LaunchCircle(circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji, followerIDArray: followerIDArray)
        self.delegate?.launchCircleUpdated(circleID: self.circleID, launchCircle: launchCircle)
    }
    
    
    
    
    //MARK: - Fetchers
    
    func fetchFollowers() {
        
        db.collection("LaunchCircles").document(circleID).collection("Followers").getDocuments { (snap, err) in
            
            guard let docs = snap?.documents else { return }
            
            let followerIDArray = docs.map({$0.documentID})
            
            self.followerIDArray = followerIDArray
            
            self.triggerUpdate()
        }
        
    }
    

    func monitorMyFollow() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.myFollowListener = db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID).addSnapshotListener { (snap, err) in
            
            guard let doc = snap else { return }
            
            self.myFollow = doc.exists
            if doc.exists {
                self.followerIDArray?.removeAll(where: {$0 == myUID})
                self.followerIDArray?.append(myUID)
            } else {
                self.followerIDArray?.removeAll(where: {$0 == myUID})
            }
            
            self.triggerUpdate()
        }
        
    }
    
    
}
