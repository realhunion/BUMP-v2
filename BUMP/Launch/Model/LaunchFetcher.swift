//
//  ClubsFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 10/23/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol LaunchFetcherDelegate:class {
    func launchCircleUpdated(circleID : String, launchCircle : LaunchCircle)
    func launchCircleRemoved(circleID : String)
}

class LaunchFetcher {
    
    var db = Firestore.firestore()
    
    var campusListener : ListenerRegistration?
    
    weak var delegate : LaunchFetcherDelegate?
    
    var launchCircleFetcherDict : [String : LaunchCircleFetcher] = [:]
    
    init() {
    }
    
    func shutDown() {
        self.delegate = nil
        if let listenr = campusListener {
            listenr.remove()
        }
        
        launchCircleFetcherDict.forEach({$0.value.shutDown()})
    }
    
    
    //MARK:- MAIN
    
    func monitorLaunchCircles() {
        
        self.campusListener = db.collection("LaunchCircles").addSnapshotListener { (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            docChanges.forEach { (diff) in
                
                if (diff.type == .added) {
                    
                    let circleID = diff.document.documentID
                    let data = diff.document.data()
                    if let circleName = data["circleName"] as? String, let circleEmoji = data["circleEmoji"] as? String {
                        
                        self.monitorLaunchCircle(circleID: circleID, circleName: circleName, circleEmoji : circleEmoji)
                        
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
    
    func monitorLaunchCircle(circleID : String, circleName : String, circleEmoji : String) {
        
        let launchCircleFetcher = LaunchCircleFetcher(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
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



extension LaunchFetcher : LaunchCircleFetcherDelegate {
    
    
    func launchCircleUpdated(circleID: String, launchCircle: LaunchCircle) {
        self.delegate?.launchCircleUpdated(circleID : circleID, launchCircle: launchCircle)
    }
    
    
}
