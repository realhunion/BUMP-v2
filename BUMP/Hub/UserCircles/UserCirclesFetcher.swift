//
//  MyCirclesFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 1/9/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase


struct Circle {
    var circleID : String
    var circleName : String
    var circleEmoji : String
}

protocol UserCirclesFetcherDelegate : class {
    func userCirclesFetched(circleArray : [Circle])
}

class UserCirclesFetcher {
    
    var db = Firestore.firestore()
    
    var delegate : UserCirclesFetcherDelegate?
    
    var userID : String
    init(userID : String) {
        self.userID = userID
    }
    
    
    func fetchUserCircles() {
        
        db.collection("User-Profile").document(self.userID).collection("Following").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { return }
            
            let circleIDArray = docs.map({$0.documentID})
            
            self.fetchCircleArrayInfo(circleIDArray: circleIDArray)
        }
        
    }
    
    //FIX: in the future when many LaunchCircles not effective
    func fetchCircleArrayInfo(circleIDArray : [String]) {
        
        db.collection("LaunchCircles").getDocuments { (snap, err) in
            
            guard let docs = snap?.documents else { return }
            
            let userCirclesSnaps = docs.filter({circleIDArray.contains($0.documentID)})
            
            var userCirclesArray : [Circle] = []
            for snap in userCirclesSnaps {
                if let circleEmoji = snap.data()["circleEmoji"] as? String, let circleName = snap.data()["circleName"] as? String {
                    let circleID = snap.documentID
                    let c = Circle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
                    userCirclesArray.append(c)
                }
            }
            
            self.delegate?.userCirclesFetched(circleArray: userCirclesArray)
            
        }
        
    }
    
    
    
    
}
