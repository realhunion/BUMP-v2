//
//  ClubsFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 10/23/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol ClubsFetcherDelegate:class {
    func clubUpdated(clubInfo : ClubInfo)
    func clubRemoved(clubID : String)
}

struct ClubInfo {
    var circleID : String
    var followerIDArray : [String]
    var userHereArray : [UserHere]
}

class ClubsFetcher {
    
    var db = Firestore.firestore()
    
    var followingListener : ListenerRegistration?
    var campusListener : ListenerRegistration?
    
    weak var delegate : ClubsFetcherDelegate?
    
    
    var circleInfoFetcherDict : [String : CircleInfoFetcher] = [:]
    var clubFollowerFetcherDict : [String : ClubFollowersFetcher] = [:]
    
    
    var clubUsersHereDict : [String : [UserHere]] = [:]
    var clubFollowerIDsDict : [String : [String]] = [:]
    
    init() {
    }
    
    func shutDown() {
        self.delegate = nil
        if let listenr = followingListener {
            listenr.remove()
        }
        if let listenr = campusListener {
            listenr.remove()
        }
        circleInfoFetcherDict.forEach({$0.value.shutDown()})
        clubFollowerFetcherDict.forEach({$0.value.shutDown()})
    }
    
    
    //MARK:- MAIN
    
    func monitorCampusClubs() {
        
        self.campusListener = db.collection("LaunchCircles").addSnapshotListener { (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            docChanges.forEach { (diff) in
                
                if (diff.type == .added) {
                    
                    let circleID = diff.document.documentID
                    self.monitorClub(clubID: circleID)
                    
                }
                
                if (diff.type == .removed) {
                    
                    let circleID = diff.document.documentID
                    self.deMonitorClub(clubID: circleID)
                    
                }
                
            }
            
        }
    }
    
    func monitorClubsFollowing() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.followingListener = db.collection("User-Profile").document(myUID).collection("Following").addSnapshotListener { (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            docChanges.forEach { (diff) in
                
                if (diff.type == .added) {
                    
                    let circleID = diff.document.documentID
                    self.monitorClub(clubID: circleID)
                    
                }
                
                if (diff.type == .removed) {
                    
                    let circleID = diff.document.documentID
                    self.deMonitorClub(clubID: circleID)
                    
                }
                
            }
            
        }
        
    }
    
    func monitorCategoryClubs(categoryID : String) {
        
        self.campusListener = db.collection("Clubs").whereField("category", isEqualTo: categoryID).addSnapshotListener { (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            docChanges.forEach { (diff) in
                
                if (diff.type == .added) {
                    
                    let circleID = diff.document.documentID
                    self.monitorClub(clubID: circleID)
                    
                }
                
                if (diff.type == .removed) {
                    
                    let circleID = diff.document.documentID
                    self.deMonitorClub(clubID: circleID)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    //MARK:- Monitor / DeMonitor Individual Clubs
    
    func monitorClub(clubID : String) {
        
        self.monitorClubFollowers(circleID: clubID)
        self.monitorCircleInfo(circleID: clubID)
        
    }
    
    func deMonitorClub(clubID : String) {
        
        if let c = self.circleInfoFetcherDict[clubID] {
            c.shutDown()
            c.delegate = nil
            self.circleInfoFetcherDict[clubID] = nil
            self.clubUsersHereDict[clubID] = nil
        }
        
        if let c = self.clubFollowerFetcherDict[clubID] {
            c.shutDown()
            c.delegate = nil
            self.clubFollowerFetcherDict[clubID] = nil
            self.clubFollowerIDsDict[clubID] = nil
        }
        
        self.delegate?.clubRemoved(clubID: clubID)
        //FIX : make function cleaner organized better
        
    }
    
    
    
    
    //MARK:- Monitor Individual Club Attributes
    
    
    func monitorClubFollowers(circleID : String) {
        
        guard self.clubFollowerFetcherDict[circleID] == nil else { return }
        
        let m = ClubFollowersFetcher(circleID: circleID)
        m.startMonitor()
        m.delegate = self
        
        self.clubFollowerFetcherDict[circleID] = m
        
    }
    
    func monitorCircleInfo(circleID : String) {
        
        guard self.circleInfoFetcherDict[circleID] == nil else { return }
        
        let m = CircleInfoFetcher(circleID: circleID)
        m.monitorUsersHere()
        m.delegate = self
        
        self.circleInfoFetcherDict[circleID] = m
        
        
    }
    
    
    
    
    
    
    func triggerUpdate(circleID : String) {
        
        guard let userHereArray = self.clubUsersHereDict[circleID] else { return }
        guard let followerIDArray = self.clubFollowerIDsDict[circleID] else { return }
        
        let c = ClubInfo(circleID: circleID, followerIDArray: followerIDArray, userHereArray: userHereArray)
        self.delegate?.clubUpdated(clubInfo: c)
        
    }
    
    
    
    
    
}


extension ClubsFetcher : CircleInfoFetcherDelegate {
    
    func userHereAdded(circleID: String, userHere: UserHere) {}
    func userHereRemoved(circleID: String, userID: String) {}
    
    
    func usersHereUpdated(circleID: String, userHereArray: [UserHere]) {
        
        self.clubUsersHereDict[circleID] = userHereArray
        
        self.triggerUpdate(circleID: circleID)
    }
    
}


extension ClubsFetcher : ClubFollowersFetcherDelegate {
    
    func clubFollowersUpdated(circleID: String, followerIDArray: [String]) {
        
        self.clubFollowerIDsDict[circleID] = followerIDArray
        
        self.triggerUpdate(circleID: circleID)
    }
    
}
