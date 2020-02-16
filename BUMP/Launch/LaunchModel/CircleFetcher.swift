//
//  CircleFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

struct CircleInfo {
    var circleID : String
    var circleName : String
    var circleEmoji : String
    var circleDescription : String
}

protocol CircleFetcherDelegate : class {
    func launchCircleUpdated(circleID : String, launchCircle : LaunchCircle)
}

class CircleFetcher {
    
    deinit {
        print("deinited launchCircleFetcher \(circleID)")
    }
    
    var db = Firestore.firestore()
    
    var myFollowListener : ListenerRegistration?
    
    weak var delegate : CircleFetcherDelegate?
    
    var circleInfo : CircleInfo? = nil
    var memberArray : [LaunchMember]? = nil
    //    var myMember : LaunchMember? = nil
    
    var circleID : String
    init(circleID : String) {
        self.circleID = circleID
    }
    
    func shutDown() {
        self.delegate = nil
        if let listenr = self.myFollowListener {
            listenr.remove()
        }
        self.memberArray = nil
    }
    
    
    //MARK: - MAIN
    
    func startMonitors() {
        self.fetchFollowers()
        self.fetchInfo()
    }
    
    func triggerUpdate() {
        
        guard let memArray = self.memberArray else { return }
        guard let circInfo = self.circleInfo else { return }
        
        let launchCircle = LaunchCircle(circleID: circInfo.circleID, circleName: circInfo.circleName, circleEmoji: circInfo.circleEmoji, circleDescription: circInfo.circleDescription, memberArray: memArray)
        self.delegate?.launchCircleUpdated(circleID: self.circleID, launchCircle: launchCircle)
    }
    
    
    
    
    //MARK: - Fetchers
    
    
    func fetchInfo() {
        db.collection("LaunchCircles").document(circleID).getDocument { (snap, err) in
            guard let data = snap?.data() else { return }
            
            if let circleName = data["circleName"] as? String, let circleEmoji = data["circleEmoji"] as? String, let circleDescription = data["circleDescription"] as? String {
                let info = CircleInfo(circleID: self.circleID, circleName: circleName, circleEmoji: circleEmoji, circleDescription: circleDescription)
                self.circleInfo = info
            }
            
        }
    }
    
    
    func fetchFollowers() {
        
        db.collection("LaunchCircles").document(circleID).collection("Followers").getDocuments { (snap, err) in
            
            guard let docs = snap?.documents else { return }
            
            var mArray : [LaunchMember] = []
            for doc in docs {
                
                let userID = doc.documentID
                if let notifsOn = doc.data()["notificationsOn"] as? Bool {
                    let member = LaunchMember(userID: userID, notifsOn: notifsOn)
                    mArray.append(member)
                } else {
                    let member = LaunchMember(userID: userID, notifsOn: false)
                    mArray.append(member)
                }
                //FIX: not propoer. should contains notifsOn field always.
            }
            
            self.memberArray = mArray
            
            guard let myUID = Auth.auth().currentUser?.uid else { self.triggerUpdate(); return }
            
            self.myFollowListener = self.db.collection("LaunchCircles").document(self.circleID).collection("Followers").document(myUID).addSnapshotListener { (snap, err) in
                
                guard let doc = snap else { return }
                
                self.memberArray?.removeAll(where: {$0.userID == myUID})
                
                if let notifsOn = doc.data()?["notificationsOn"] as? Bool {
                    let member = LaunchMember(userID: doc.documentID, notifsOn: notifsOn)
                    self.memberArray?.append(member)
                }
                
                self.triggerUpdate()
            }
        }
        
    }
    
    
}
