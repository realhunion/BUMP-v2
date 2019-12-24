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
    
}


class FeedFetcher {
    
    var delegate : FeedFetcherDelegate?
    
    var db = Firestore.firestore()
    var listener : ListenerRegistration?
    
    var feedChatFetcherArray : [FeedChatFetcher] = []
    
    init() {
    }
    
    func shutDown() {
        
        for fetcher in self.feedChatFetcherArray {
            fetcher.delegate = nil
            fetcher.shutDown()
        }
        self.feedChatFetcherArray = []
        if let listenr = listener {
            listenr.remove()
        }
        self.delegate = nil
        
    }
    
    
    func startMonitor() {
        self.listener = db.collection("Feed").addSnapshotListener { (snap, err) in
            guard let diffArray = snap?.documentChanges else { return }
            
            for diff in diffArray {
                
                if diff.type == .added {
                    
                    let doc = diff.document
                    let chatID = doc.documentID
                    if let circleID = doc.data()["circleID"] as? String, let circleName = doc.data()["circleName"] as? String {
                        
                        self.monitorFeedChat(chatID: chatID, circleID: circleID, circleName: circleName)
                        
                    }
                    
                }
                else if diff.type == .removed {
                    
                    let doc = diff.document
                    let chatID = doc.documentID
                    
                    self.deMonitorFeedChat(chatID: chatID)
                    
                }
            }
        }
    }
    
    
    func monitorFeedChat(chatID: String, circleID: String, circleName: String) {
        
        let fetcher = FeedChatFetcher(chatID: chatID, circleID: circleID, circleName: circleName)
        fetcher.delegate = self
        fetcher.startMonitor()
        
        self.feedChatFetcherArray.append(fetcher)
        
    }
    
    func deMonitorFeedChat(chatID : String) {
        
        let fetcher = self.feedChatFetcherArray.first(where: {$0.chatID == chatID})
        fetcher?.delegate = nil
        fetcher?.shutDown()
        
        self.feedChatFetcherArray.removeAll(where: {$0.chatID == chatID})
        
        self.delegate?.feedChatRemoved(chatID: chatID)
        
        
    }
    
    
    
}



extension FeedFetcher : FeedChatFetcherDelegate {
    
    
    func feedChatUpdated(feedChat: FeedChat) {
        self.delegate?.feedChatUpdated(feedChat: feedChat)
        
    }
    
    
}
