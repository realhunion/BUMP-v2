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
    
    func feedCircleEmpty(circleID : String)
}

class FeedCircleFetcher {
    
    var db = Firestore.firestore()
    
    var listener : ListenerRegistration?
    
    weak var delegate : FeedCircleFetcherDelegate?
    
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
        self.feedChatFetcherArray.removeAll()
    }
    
    
    //MARK:- MAIN
    
    
    func startMonitor() {
        
        DispatchQueue.main.async {
            
            self.listener = self.db.collection("Feed").whereField("circleID", isEqualTo: self.circleID).addSnapshotListener({ (snap, err) in
                guard let docChanges = snap?.documentChanges else { return }
                guard let docs = snap?.documents else { return }
                
                if docs.isEmpty {
                    self.delegate?.feedCircleEmpty(circleID: self.circleID)
                }
                
                for diff in docChanges {
                    
                    if diff.type == .added {
                        let doc = diff.document
                        let chatID = doc.documentID
                        if let circleID = doc.data()["circleID"] as? String, let circleName = doc.data()["circleName"] as? String, let circleEmoji = doc.data()["circleEmoji"] as? String {
                            self.monitorFeedChat(chatID: chatID, circleID: self.circleID, circleName: circleName, circleEmoji: circleEmoji)
                        }
                    }
                    if diff.type == .removed {
                        let chatID = diff.document.documentID
                        self.deMonitorFeedChat(chatID: chatID)
                    }
                    
                }
            })
            
        }}
    
    
    
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
