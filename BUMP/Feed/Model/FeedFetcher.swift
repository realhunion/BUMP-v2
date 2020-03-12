//
//  FeedFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 12/5/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase



protocol FeedFetcherDelegate : class {
    
    func feedChatUpdated(feedChat : FeedChat)
    
    func feedChatRemoved(chatID : String)
    
    func feedEmpty()
}


class FeedFetcher {
    
    weak var delegate : FeedFetcherDelegate?
    
    var db = Firestore.firestore()
    
    var listener : ListenerRegistration?
    
    var feedCircleFetcherArray : [FeedCircleFetcher] = []
    
    init() {
    }
    
    func shutDown() {
        
        self.delegate = nil
        if let listenr = listener {
            listenr.remove()
        }
        for fetcher in self.feedCircleFetcherArray {
            fetcher.shutDown()
        }
        feedCircleFetcherArray.removeAll()
        
    }
    
    func startMonitor() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.listener = db.collection("User-Profile").document(myUID).collection("Following").addSnapshotListener { (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            guard let docs = snap?.documents else { return }
            
            if docs.isEmpty {
                self.delegate?.feedEmpty()
            }
            
            for diff in docChanges {
                
                if diff.type == .added {
                    let circleID = diff.document.documentID
                    self.monitorFeedCircle(circleID: circleID)
                }
                if diff.type == .removed {
                    let circleID = diff.document.documentID
                    self.deMonitorFeedCircle(circleID: circleID)
                }
                
            }
        }
        
    }
    
    
    func monitorFeedCircle(circleID : String) {
        
        let fetcher = FeedCircleFetcher(circleID: circleID)
        fetcher.delegate = self
        fetcher.startMonitor()
        
        self.feedCircleFetcherArray.append(fetcher)
        
    }
    
    func deMonitorFeedCircle(circleID : String) {
        
        guard let circleFetcher = self.feedCircleFetcherArray.first(where: {$0.circleID == circleID}) else { return }
        
        for chatFetcher in circleFetcher.feedChatFetcherArray {
            ChatFollower.shared.unFollowChat(chatID: chatFetcher.chatID)
            self.delegate?.feedChatRemoved(chatID: chatFetcher.chatID)
        }
        
        circleFetcher.shutDown()
        
        self.feedCircleFetcherArray.removeAll(where: {$0.circleID == circleID})

        
    }


    
    
    
    //MARK: - TOOLBOX
    
    func doChatsExist(chatIDArray : [String]) {
        
        for chatID in chatIDArray {
            
            db.collection("Feed").document(chatID).getDocument { (snap, err) in
                guard let doc = snap else { return }
                if let circleID = doc.data()?["circleID"] as? String, let circleName = doc.data()?["circleName"] as? String, let circleEmoji = doc.data()?["circleEmoji"] as? String {
                } else {
                    self.feedChatRemoved(chatID: chatID)
                }
            }
        }
    }
    
    
    
}



extension FeedFetcher : FeedCircleFetcherDelegate {
    
    
    func feedChatUpdated(feedChat: FeedChat) {
        self.delegate?.feedChatUpdated(feedChat: feedChat)
        
    }
    
    func feedChatRemoved(chatID: String) {
        self.delegate?.feedChatRemoved(chatID: chatID)
    }
    
    
    func feedCircleEmpty(circleID: String) {
        self.delegate?.feedEmpty()
        //MORE FIX: FUTURE . Improve. Current only stops spinning when one of the feedCircles is Empty.
    }
    
}
