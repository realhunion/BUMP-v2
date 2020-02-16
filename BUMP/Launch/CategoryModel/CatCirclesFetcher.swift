//
//  ClubsFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 10/23/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol CatCirclesFetcherDelegate:class {
    func launchCircleUpdated(circleID : String, launchCircle : LaunchCircle)
    func launchCircleRemoved(circleID : String)
}

class CatCirclesFetcher {
    
    deinit {
        print("deinited launchFetcher")
    }
    
    var db = Firestore.firestore()
    
    weak var delegate : CatCirclesFetcherDelegate?
    
    var launchCircleFetcherDict : [String : CategoryCircleFetcher] = [:]
    
    
    var categoryID : String
    init(categoryID : String) {
        self.categoryID = categoryID
    }
    
    func shutDown() {
        self.delegate = nil
        
        launchCircleFetcherDict.forEach({$0.value.shutDown()})
        launchCircleFetcherDict.removeAll()
    }
    
    
    //MARK:- MAIN
    
    func monitorCategoryCircles() {
        
        db.collection("LaunchCircles").whereField("category", isEqualTo: self.categoryID).addSnapshotListener { (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            docChanges.forEach { (diff) in
                
                if (diff.type == .added) {
                    
                    let circleID = diff.document.documentID
                    let data = diff.document.data()
                    if let circleName = data["circleName"] as? String, let circleEmoji = data["circleEmoji"] as? String, let circleDescription = data["circleDescription"] as? String {
                        
                        self.monitorLaunchCircle(circleID: circleID, circleName: circleName, circleEmoji : circleEmoji, circleDescription : circleDescription)
                        
                    }
                }
                
                if (diff.type == .removed) {
                    
                    let circleID = diff.document.documentID
                    self.deMonitorLaunchCircle(circleID: circleID)
                    self.delegate?.launchCircleRemoved(circleID: circleID)
                }
                
            }
            
        }
    }
    
    
    
    
    
    //MARK:- Monitor / DeMonitor Individual Clubs
    
    func monitorLaunchCircle(circleID : String, circleName : String, circleEmoji : String, circleDescription : String) {
        
        let launchCircleFetcher = CategoryCircleFetcher(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji, circleDescription: circleDescription)
        self.launchCircleFetcherDict[circleID] = launchCircleFetcher
        
        launchCircleFetcher.delegate = self
        launchCircleFetcher.startMonitors()
        
    }
    
    func deMonitorLaunchCircle(circleID : String) {
        
        if let c = self.launchCircleFetcherDict[circleID] {
            c.shutDown()
            c.delegate = nil
            self.launchCircleFetcherDict[circleID] = nil
        }
        
    }
    
    
    
    
    
    
    
}



extension CatCirclesFetcher : CategoryCircleFetcherDelegate {
    
    
    func launchCircleUpdated(circleID: String, launchCircle: LaunchCircle) {
        self.delegate?.launchCircleUpdated(circleID : circleID, launchCircle: launchCircle)
    }
    
    
}
