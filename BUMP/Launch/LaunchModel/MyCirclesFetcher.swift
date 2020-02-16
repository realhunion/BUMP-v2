//
//  MyCirclesFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol MyCirclesFetcherDelegate:class {
    func circleUpdated(circleID : String, launchCircle : LaunchCircle)
    func circleRemoved(circleID : String)
}

class MyCirclesFetcher {
    
    deinit {
        print("deinited launchFetcher")
    }
    
    var db = Firestore.firestore()
    
    var listener : ListenerRegistration?
    
    weak var delegate : CatCirclesFetcherDelegate?
    
    var circleFetcherDict : [String : CircleFetcher] = [:]
    
    init() {
    }
    
    func shutDown() {
        self.delegate = nil
        if let listenr = self.listener {
            listenr.remove()
        }
        
        circleFetcherDict.forEach({$0.value.shutDown()})
        circleFetcherDict.removeAll()
    }
    
    
    //MARK:- MAIN
    
    func monitorMyCircles() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.listener = db.collection("User-Profile").document(myUID).collection("Following").addSnapshotListener { (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            docChanges.forEach { (diff) in
                
                if (diff.type == .added) {
                    
                    let circleID = diff.document.documentID
                    self.monitorCircle(circleID: circleID)
                    
                }
                
                if (diff.type == .removed) {
                    
                    let circleID = diff.document.documentID
                    self.deMonitorCircle(circleID: circleID)
                    self.delegate?.launchCircleRemoved(circleID: circleID)
                }
                
            }
            
        }
    }
    
    
    
    
    
    //MARK:- Monitor / DeMonitor Individual Clubs
    
    func monitorCircle(circleID : String) {
        
        let fetcher = CircleFetcher(circleID: circleID)
        self.circleFetcherDict[circleID] = fetcher
        
        fetcher.delegate = self
        fetcher.startMonitors()
        
    }
    
    func deMonitorCircle(circleID : String) {
        
        if let fetcher = self.circleFetcherDict[circleID] {
            fetcher.shutDown()
            self.circleFetcherDict[circleID] = nil
        }
        
    }
    
    
    
}



extension MyCirclesFetcher : CircleFetcherDelegate {
    
    
    func launchCircleUpdated(circleID: String, launchCircle: LaunchCircle) {
        self.delegate?.launchCircleUpdated(circleID: circleID, launchCircle: launchCircle)
    }
    
    
    
    
    
}
