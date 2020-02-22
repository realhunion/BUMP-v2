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
        if isLaunched {
            self.postTextToFirebase(text: text)
        } else {
            self.postLaunchTextToFirebase(text: text)
            UserDefaultsManager.shared.launchedLaunchCircle(circleID: circleID)
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
        
        let msgID = "\(Date().millisecondsSince1970)"
        
        let msgRef = db.collection("Feed").document(chatID).collection("Messages").document(msgID)
        let msgData = generateMsgDataStrip(text: text, userID: myUID, userName: myUsername)
        batch.setData(msgData, forDocument: msgRef)
        
        let infoRef = db.collection("Feed").document(chatID)
        let infoData = [
            "circleID":circleID,
            "circleName":circleName,
            "circleEmoji":circleEmoji,
            "timeLaunched": msgData["timestamp"] as Any,
            "firstMsgText": text,
            ] as [String : Any]
        batch.setData(infoData, forDocument: infoRef, merge: true)
        
        batch.commit { (err) in
            guard err == nil else { return }
            
        }
        
    }
    
    
    
    
    
    
    
}
