//
//  CircleAnalytics.swift
//  BUMP
//
//  Created by Hunain Ali on 2/3/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

class CircleAnalytics {
    
    
    static let shared = CircleAnalytics()
    
    
    var db = Firestore.firestore()
    
    func circleLaunched(circleID : String) {
        
        print("cott 1")
        let ref = db.collection("LaunchCircles").document(circleID)
        
        // Atomically increment the population of the city by 50.
        // Note that increment() with no arguments increments by 1.
        
        ref.updateData([
            "timesLaunched": FieldValue.increment(Int64(1))
        ])
        
        print("cott 2")
        
    }
    
    
    
    
}
