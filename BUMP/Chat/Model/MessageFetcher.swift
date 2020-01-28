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
    func newMessagesAdded(messages : [Message])
}


class MessageFetcher {
    
    let db = Firestore.firestore()
    var listener : ListenerRegistration?
    
    weak var delegate: MessageFetcherDelegate?
    
    var chatID : String
    init(chatID : String) {
        self.chatID = chatID
        print("vv msgfetcher INIT \(chatID)")
    }
    
    deinit {
        print("vv msgfetcher DE INIT \(chatID)")
    }
    
    
    
    func startMonitor() {
        
        let ref = db.collection("Feed").document(chatID).collection("Messages")
        self.listener = ref.addSnapshotListener({ (snap, err) in
            guard let docChanges = snap?.documentChanges else {
                //error
                return
            }
            var msgArray : [Message] = []
            docChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    if let userID = data["userID"] as? String,
                        let userName = data["userName"] as? String,
                        let text = data["text"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp {
                        
                        let msg : Message = Message(userID: userID, userName: userName, text: text, timestamp: timestamp)
                        msgArray.append(msg)
                    }
                }
            }
            if !msgArray.isEmpty {
                self.delegate?.newMessagesAdded(messages: msgArray)
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
