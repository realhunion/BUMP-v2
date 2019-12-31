//
//  LaunchMessageSender.swift
//  BUMP
//
//  Created by Hunain Ali on 12/31/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

class LaunchMessageSender : MessageSender {
    
    var isLaunched = false
    
    var circleID : String
    var circleName : String
    var circleEmoji : String
    init(chatID: String, circleID: String, circleName: String, circleEmoji : String) {
        self.circleID = circleID
        self.circleName = circleName
        self.circleEmoji = circleEmoji
        super.init(chatID: chatID)
    }
    
    
    //MARK: - Send Msg
    
    
    override func sendMsg(text: String) {
        print("crr -1")
        if isLaunched {
            print("crr1 \(isLaunched)")
            self.postTextToFirebase(text: text)
        } else {
            print("crr2 \(isLaunched)")
            self.postLaunchTextToFirebase(text: text)
            self.isLaunched = true
        }
    }
    
    
    func postLaunchTextToFirebase(text : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        guard var myUsername = Auth.auth().currentUser?.displayName else { return }
        //FIX: do some if not accepted
        
        
        // Submit only first name-
        if let myUserFirstName = myUsername.components(separatedBy: " ").first {
            myUsername = myUserFirstName
        }
        
        
        let batch = db.batch()
        
        let timestamp = generateUniqueTimestamp()
        
        let msgRef = db.collection("Feed").document(chatID).collection("Messages").document(timestamp)
        let msgData = generateMsgDataStrip(text: text, userID: myUID, userName: myUsername)
        batch.setData(msgData, forDocument: msgRef)
        
        let infoRef = db.collection("Feed").document(chatID)
        let infoData = [
            "circleID":circleID,
            "circleName":circleName,
            "circleEmoji":circleEmoji,
            "timeLaunched": msgData["timestamp"] as Any,
            ] as [String : Any]
        batch.setData(infoData, forDocument: infoRef, merge: true)
        
        CircleManager.shared.updateFeedLastSeen(chatID: chatID)
        //FIX: new pathway
        
        batch.commit()
        
    }
    
    
    
    
    
    
    
}
