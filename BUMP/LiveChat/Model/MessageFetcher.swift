//
//  MessagesFetcher.swift
//  OASIS2
//
//  Created by Honey on 5/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase


protocol MessageFetcherDelegate: class {
    func newMessagesAdded(messages : [Message], initialLoadDone : Bool)
}

class MessageFetcher {
    
    final let lastXSecondsToLoadLive = 7
    
    let db = Firestore.firestore()
    var listener : ListenerRegistration?
    
    weak var delegate: MessageFetcherDelegate?
    
    var chatID : String
    init(chatID : String) {
        self.chatID = chatID
        self.startMonitor()
        print("vv msgfetcher INIT \(chatID)")
    }
    
    deinit {
        print("vv msgfetcher DE INIT \(chatID)")
    }
    
    var initialLoadDone = false
    
    func startMonitor() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Feed").document(chatID).collection("Messages")
        listener = ref.addSnapshotListener(includeMetadataChanges: false, listener: { (snap, err) in
            guard let docChanges = snap?.documentChanges else {
                //error
                return
            }
            
            if !self.initialLoadDone {
                var msgs : [Message] = []
                docChanges.reversed().forEach { diff in
                    if (diff.type == .added) {
                        let data = diff.document.data()
                        if let userID = data["userID"] as? String,
                            let userName = data["userName"] as? String,
                            let text = data["text"] as? String,
                            let timestamp = data["timestamp"] as? Timestamp {
                            
                            let msg : Message = Message(userID: userID, userName: userName, text: text, timestamp: timestamp)
                            msgs.append(msg)
                            
                        }
                    }
                }
                self.initialLoadDone = true
                self.delegate?.newMessagesAdded(messages: msgs, initialLoadDone: false)
            }
            else {
                docChanges.forEach({ (diff) in
                    if (diff.type == .added) {
                        let data = diff.document.data()
                        if let userID = data["userID"] as? String,
                            let userName = data["userName"] as? String,
                            let text = data["text"] as? String,
                            let timestamp = data["timestamp"] as? Timestamp {
                            
                            //make sure msg received within 7 seconds else ew.
                            if self.inLastXSeconds(xSeconds: self.lastXSecondsToLoadLive, timestamp: timestamp) {
                                
                                let msg : Message = Message(userID: userID, userName: userName, text: text, timestamp: timestamp)
                                self.delegate?.newMessagesAdded(messages: [msg], initialLoadDone: true)
                                
                            }
                        }
                    }
                })
            }
        })
    }
    
    func shutDown() {
        if let listenr = listener {
            listenr.remove()
        }
        self.delegate = nil
    }
    
    
    
    
    
    
    //MARK: - Helper Methods
    
    func inLastXSeconds(xSeconds : Int, timestamp: Timestamp) -> Bool {
        let currentTime = Int64(Date().timeIntervalSince1970)
        let difference = currentTime - timestamp.seconds
        if difference >= 0 && difference <= Int64(xSeconds) {
            return true
        } else {
            return false
        }
    }
    
    
    
}
