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
    
    var delegate : FeedChatFetcherDelegate?
    
    var db = Firestore.firestore()
    
    var messageFetcher : MessageFetcher?
    var messageArray : [Message]? = nil
    
    var myUserListener : ListenerRegistration?
    var myUser : FeedUser? = nil
    
    var userArray : [FeedUser]? = nil
    
    var isMyCircleListener : ListenerRegistration?
    var isMyCircle : Bool? = nil
    
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
        if let listenr = self.myUserListener {
            listenr.remove()
        }
        self.messageFetcher?.shutDown()
        self.delegate = nil
    }
    
    
    
    
    func startMonitor() {
        self.monitorIsMyCircle()
        self.monitorMyFeedUser()
        self.fetchFeedUsers()
        self.fetchFeedChatMessages()
    }
    
    func triggerUpdate() {
        
        guard let isMCircle = self.isMyCircle else { return }
        guard let myU = self.myUser else { return }
        guard let uArray = self.userArray else { return }
        guard let msgArray = self.messageArray else { return }
        
        let payload = FeedChat(chatID: self.chatID, circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji, myUser: myU, isMyCircle: isMCircle, userArray: uArray, messageArray: msgArray)
        self.delegate?.feedChatUpdated(feedChat: payload)
        
    }
    
    
    
    //MARK:- Fetchers
    
    func monitorIsMyCircle() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
         db.collection("User-Profile").document(myUID).collection("Following").document(circleID).addSnapshotListener { (snap, err) in
            guard let doc = snap else { return }
            
            self.isMyCircle = doc.exists
            self.triggerUpdate()
        }
        
    }
    
    func monitorMyFeedUser() {
        
        //FIX: still be able to show TVC even if myUID absent.
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Feed").document(chatID).collection("Users").document(myUID).addSnapshotListener { (snap, err) in
            
            guard let doc = snap else { return }
            
            let uID = doc.documentID
            var fUser = FeedUser(userID: uID)
            if let lastSeen = doc.data()?["lastSeen"] as? Timestamp {
                fUser.lastSeen = lastSeen
            }
            if let isFollowing = doc.data()?["isFollowing"] as? Bool {
                fUser.isFollowing = isFollowing
            }
            
            self.myUser = fUser
            self.triggerUpdate()
            
        }
        
    }
    
    func fetchFeedUsers() {
        
        db.collection("Feed").document(chatID).collection("Users").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { return }
            
            var uArray : [FeedUser] = []
            for doc in docs {
                let uID = doc.documentID
                var fUser = FeedUser(userID: uID)
                if let lastSeen = doc.data()["lastSeen"] as? Timestamp {
                    fUser.lastSeen = lastSeen
                }
                if let isFollowing = doc.data()["isFollowing"] as? Bool {
                    fUser.isFollowing = isFollowing
                }
                uArray.append(fUser)
            }
        
            self.userArray = uArray
            self.triggerUpdate()
            
        }
        
    }
    
    func fetchFeedChatMessages() {
        
        self.messageFetcher = MessageFetcher(chatID: chatID)
        self.messageFetcher?.delegate = self
        self.messageFetcher?.startMonitor()
        
    }
    
    
    
    
}


extension FeedChatFetcher : MessageFetcherDelegate {
    
    
    func newMessagesAdded(messages: [Message]) {
        if self.messageArray == nil { self.messageArray = [] }
        self.messageArray?.append(contentsOf: messages)
        self.triggerUpdate()
    }
    
    
}
