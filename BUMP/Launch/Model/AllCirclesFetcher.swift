//
//  AllCirclesFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 2/15/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol AllCirclesFetcherDelegate : class {
    func allCirclesFetched(launchCircleArray : [LaunchCircle])
}

class AllCirclesFetcher {
    
    var db = Firestore.firestore()
    
    weak var delegate : AllCirclesFetcherDelegate?
    
    var circleFetchedDict : [String:Bool] = [:]
    var amMemberListenerArray : [ListenerRegistration] = []
    var launchCircleArray : [LaunchCircle] = []
    
    
    func shutDown() {
        self.delegate = nil
        for listener in self.amMemberListenerArray {
            listener.remove()
        }
        self.circleFetchedDict.removeAll()
        self.amMemberListenerArray.removeAll()
        self.launchCircleArray.removeAll()
    }
    
    func fetchAllCircles() {
        
        db.collection("LaunchCircles").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                let circleID = doc.documentID
                if let circleName = doc.data()["circleName"] as? String, let circleEmoji = doc.data()["circleEmoji"] as? String, let circleDescription = doc.data()["circleDescription"] as? String, let category = doc.data()["category"] as? String {
                    
                    self.circleFetchedDict[circleID] = false
                }
            }
            
            for doc in docs {
                let circleID = doc.documentID
                if let circleName = doc.data()["circleName"] as? String, let circleEmoji = doc.data()["circleEmoji"] as? String, let circleDescription = doc.data()["circleDescription"] as? String, let category = doc.data()["category"] as? String {
                    
                    self.fetchCircle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji, circleDescription: circleDescription, category : category)
                    
                    
                }
            }
        }
        
    }
    
    func fetchCircle(circleID : String, circleName : String, circleEmoji : String, circleDescription : String, category : String) {
        
        db.collection("LaunchCircles").document(circleID).collection("Followers").getDocuments { (snap, err) in
            
            guard let docs = snap?.documents else { return }
            
            var memberArray : [LaunchMember] = []
            for doc in docs {
                var notifsOn = false
                if let notificationsOn = doc.data()["notificationsOn"] as? Bool {
                    notifsOn = notificationsOn
                }
                
                let lm = LaunchMember(userID: doc.documentID, notifsOn: notifsOn)
                memberArray.append(lm)
                
            }
            
            let lc = LaunchCircle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji, circleDescription: circleDescription, category: category, memberArray: memberArray)
            self.launchCircleArray.removeAll(where: {$0.circleID == circleID})
            self.launchCircleArray.append(lc)
            
            self.circleFetchedDict[circleID] = true
            self.triggerUpdate()
//            My Follow Listener

            self.monitorAmMember(circleID: circleID)

        }
        
    }
    
    
    
    func monitorAmMember(circleID : String) {
        
        var firstFetchCompleted = false
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let amMemberListener = self.db.collection("LaunchCircles").document(circleID).collection("Followers").document(myUID).addSnapshotListener { (snap, err) in
            
            guard firstFetchCompleted else { firstFetchCompleted = true; return }
            
            guard let doc = snap else { return }
            
            guard doc.exists else {
                self.launchCircleArray.first(where: {$0.circleID == circleID})?.memberArray.removeAll(where: {$0.userID == myUID})
                self.triggerUpdate()
                return
            }
            
            self.launchCircleArray.first(where: {$0.circleID == circleID})?.memberArray.removeAll(where: {$0.userID == myUID})
            var notifsOn = false
            if let notificationsOn = doc.data()?["notificationsOn"] as? Bool {
                notifsOn = notificationsOn
            }
            let lm = LaunchMember(userID: myUID, notifsOn: notifsOn)
            self.launchCircleArray.first(where: {$0.circleID == circleID})?.memberArray.append(lm)
            
            self.circleFetchedDict[circleID] = true
            self.triggerUpdate()
        }
        
        self.amMemberListenerArray.append(amMemberListener)
        
    }
    
    
    
    
    //MARK: - TRIGGER
    
    func triggerUpdate() {
        
        guard !self.circleFetchedDict.contains(where: {$0.value == false}) else { return }
        
        print("oop yessir")
        self.delegate?.allCirclesFetched(launchCircleArray: self.launchCircleArray)
        
    }
    
    
}
