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
    
    deinit {
        print("deinited launchCircleFetcher \(circleID)")
    }
    
    var db = Firestore.firestore()
    
    var myFollowListener : ListenerRegistration?
    
    weak var delegate : LaunchCircleFetcherDelegate?
    
    
    var memberArray : [LaunchMember]? = nil
//    var myMember : LaunchMember? = nil
    
    var circleID : String
    var circleName : String
    var circleEmoji : String
    var circleDescription : String
    init(circleID : String, circleName : String, circleEmoji : String, circleDescription : String) {
        self.circleID = circleID
        self.circleName = circleName
        self.circleEmoji = circleEmoji
        self.circleDescription = circleDescription
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
    }
    
    func triggerUpdate() {
        
        guard let memArray = self.memberArray else { return }
        
        let launchCircle = LaunchCircle(circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji, circleDescription: self.circleDescription, memberArray: memArray)
        self.delegate?.launchCircleUpdated(circleID: self.circleID, launchCircle: launchCircle)
    }
    
    
    
    
    //MARK: - Fetchers
    
    
    
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
