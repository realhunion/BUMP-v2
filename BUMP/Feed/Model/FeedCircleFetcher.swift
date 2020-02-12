//
//  FeedCircleFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 2/1/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol FeedCircleFetcherDelegate : class {
    
    func feedChatUpdated(feedChat : FeedChat)
    
    func feedChatRemoved(chatID : String)
    
}

class FeedCircleFetcher {
    
    var db = Firestore.firestore()
    
    var listener : ListenerRegistration?
    
    var delegate : FeedCircleFetcherDelegate?
    
    var feedChatFetcherArray : [FeedChatFetcher] = []
    
    var circleID : String
    init(circleID : String) {
        self.circleID = circleID
    }
    
    func shutDown() {
        self.delegate = nil
        if let listenr = self.listener {
            listenr.remove()
        }
        for fetcher in self.feedChatFetcherArray {
            fetcher.shutDown()
        }
    }
    
    
    //MARK:- MAIN
    
    
    func startMonitor() {
        
        self.listener = db.collection("Feed").whereField("circleID", isEqualTo: self.circleID).addSnapshotListener({ (snap, err) in
            guard var docChanges = snap?.documentChanges else { return }

//            docChanges.sort { (d1, d2) -> Bool in
//                if let tl1 = d1.document.data()["timeLaunched"] as? Timestamp, let tl2 = d2.document.data()["timeLaunched"] as? Timestamp {
//                    return tl1.compare(tl2) == .orderedDescending
//
//                } else {
//                    return true
//                }
//            }
            
            for diff in docChanges {
                
                if diff.type == .added {
                    let doc = diff.document
                    let chatID = doc.documentID
                    if let circleName = doc.data()["circleName"] as? String, let circleEmoji = doc.data()["circleEmoji"] as? String {
                        self.monitorFeedChat(chatID: chatID, circleID: self.circleID, circleName: circleName, circleEmoji: circleEmoji)
                    }
                }
                if diff.type == .removed {
                    let chatID = diff.document.documentID
                    self.deMonitorFeedChat(chatID: chatID)
                }
                
            }
        })
        
    }
    
    
    
    func monitorFeedChat(chatID: String, circleID: String, circleName: String, circleEmoji : String) {
        
        let fetcher = FeedChatFetcher(chatID: chatID, circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        fetcher.delegate = self
        fetcher.startMonitor()
        
        self.feedChatFetcherArray.append(fetcher)
        
    }
    
    func deMonitorFeedChat(chatID : String) {
        
        guard let fetcher = self.feedChatFetcherArray.first(where: {$0.chatID == chatID}) else { return }
        fetcher.shutDown()
        
        self.feedChatFetcherArray.removeAll(where: {$0.chatID == chatID})
        
        self.delegate?.feedChatRemoved(chatID: chatID)
        
        
    }
    
    
}



extension FeedCircleFetcher : FeedChatFetcherDelegate {
    
    
    func feedChatUpdated(feedChat: FeedChat) {
        self.delegate?.feedChatUpdated(feedChat: feedChat)
    }
    
}
