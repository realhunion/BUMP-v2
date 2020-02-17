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
            
            print("joker 1.1")
            
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
        
        guard let fetcher = self.feedCircleFetcherArray.first(where: {$0.circleID == circleID}) else { return }
        fetcher.shutDown()
        
        for fetcher in fetcher.feedChatFetcherArray {
            //FIX: boom. tell jacob. unfollow chat when u leave circle.
            ChatFollower.shared.unFollowChat(chatID: fetcher.chatID)
            self.delegate?.feedChatRemoved(chatID: fetcher.chatID)
        }
        
        self.feedCircleFetcherArray.removeAll(where: {$0.circleID == circleID})

        
    }
    
    
    //MARK: - Tool
    
    //So if 100 msgs sent between time off app, doesnt refresh tableView 100 times incrementally.
    func refreshFeedChats() {
        
        for circFetcher in self.feedCircleFetcherArray {
            for chatFetcher in circFetcher.feedChatFetcherArray {
                chatFetcher.messageFetcher?.shutDown()
                chatFetcher.messageArray = nil
                chatFetcher.monitorFeedChatMessages()
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
    
    
}
