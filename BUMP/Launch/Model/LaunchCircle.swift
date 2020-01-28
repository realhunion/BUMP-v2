//
//  LaunchCircle.swift
//  BUMP
//
//  Created by Hunain Ali on 12/30/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import FirebaseAuth

class LaunchCircle {
    
    
    var circleID : String
    var circleName : String
    var circleEmoji : String
    var circleDescription : String
    var followerIDArray : [String]
    init(circleID : String, circleName : String, circleEmoji : String, circleDescription : String, followerIDArray : [String]) {
        self.circleID = circleID
        self.circleName = circleName
        self.circleEmoji = circleEmoji
        self.circleDescription = circleDescription
        self.followerIDArray = followerIDArray
    }
    
    
    
    func amFollowing() -> Bool {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return false }
        
        if followerIDArray.contains(myUID) {
            return true
        } else {
            return false
        }
        
    }
    
    
    
}
