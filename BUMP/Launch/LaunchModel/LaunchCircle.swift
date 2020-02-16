//
//  LaunchCircle.swift
//  BUMP
//
//  Created by Hunain Ali on 12/30/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import FirebaseAuth


struct LaunchMember {
    var userID : String
//    var userName : String
    var notifsOn : Bool
}

class LaunchCircle {
    
    
    var circleID : String
    var circleName : String
    var circleEmoji : String
    var circleDescription : String
    var memberArray : [LaunchMember]
    init(circleID : String, circleName : String, circleEmoji : String, circleDescription : String, memberArray : [LaunchMember]) {
        self.circleID = circleID
        self.circleName = circleName
        self.circleEmoji = circleEmoji
        self.circleDescription = circleDescription
        self.memberArray = memberArray
    }
    
    
    
    func amMember() -> Bool {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return false }
        
        if memberArray.contains(where: {$0.userID == myUID}) {
            return true
        } else {
            return false
        }
        
    }
    
    
    
}
