//
//  FeedChatFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 12/5/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase



protocol FeedChatFetcherDelegate : class {
    
    func feedChatUpdated(feedChat : FeedChat)
    
}

class FeedChatFetcher {
    
    weak var delegate : FeedChatFetcherDelegate?
    
    var db = Firestore.firestore()
    
    var messageFetcher : MessageFetcher?
    var messageArray : [Message]? = nil
    
    var myUserListener : ListenerRegistration?
    var myUser : FeedUser? = nil
    
    var chatID : String
    var circleID : String
    var circleName : String
    var circleEmoji : String
    init(chatID : String, circleID : String, circleName : String, circleEmoji : String) {
        self.chatID = chatID
        self.circleID = circleID
        self.circleName = circleName
        self.circleEmoji = circleEmoji
        
    }
    
    func shutDown() {
        self.delegate = nil
        if let listenr = self.myUserListener {
            listenr.remove()
        }
        self.messageFetcher?.shutDown()
        
        self.messageArray = nil
        self.myUser = nil
    }
    
    
    
    
    
    func startMonitor() {
        self.monitorMyUser()
        self.monitorFeedChatMessages()
    }
    
    func triggerUpdate() {
        
        guard let myFUser = self.myUser else { return }
        guard let msgArray = self.messageArray else { return }
        
        let payload = FeedChat(chatID: self.chatID, circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji, myUser: myFUser, messageArray: msgArray)
        self.delegate?.feedChatUpdated(feedChat: payload)
        
    }
    
    
    
    //MARK:- Fetchers
    
    
    func monitorMyUser() {
    
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        self.myUserListener = self.db.collection("Feed").document(self.chatID).collection("Users").document(myUID).addSnapshotListener { (snap, err) in
            
            guard let doc = snap else { return }
            
            let uID = doc.documentID
            var myFUser = FeedUser(userID: uID)
            if let lastSeen = doc.data()?["lastSeen"] as? Timestamp {
                myFUser.lastSeen = lastSeen
            }
            if let isFollowing = doc.data()?["isFollowing"] as? Bool {
                myFUser.isFollowing = isFollowing
            }
            
            self.myUser = myFUser
            self.triggerUpdate()
            
        }
        
    }
    
    func monitorFeedChatMessages() {
        
        self.messageFetcher = MessageFetcher(chatID: chatID)
        self.messageFetcher?.delegate = self
        self.messageFetcher?.startMonitor()
        
    }
    
    
    //MARK: Tool -
    
    func refreshMsgFetcher() {
        
        self.messageArray = nil
        self.messageFetcher?.shutDown()
        self.monitorFeedChatMessages()
    }
    
    
    
    
}


extension FeedChatFetcher : MessageFetcherDelegate {
    
    
    func newMessagesAdded(messages: [Message]) {
        if self.messageArray == nil { self.messageArray = [] }
        self.messageArray?.append(contentsOf: messages)
        self.triggerUpdate()
    }
    
    
}
