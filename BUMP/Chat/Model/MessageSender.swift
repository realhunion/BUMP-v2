//
//  MessageSender.swift
//  OASIS2
//
//  Created by Honey on 6/6/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

class MessageSender {
    
    let db = Firestore.firestore()
    
    var chatID : String
    init(chatID : String) {
        self.chatID = chatID
    }
    
    deinit {
        print("vv msgSender DE INIT")
    }
    
    
    
    //MARK: - Send Msg
    
    
    func sendMsg(text: String) {
        self.postTextToFirebase(text: text)
    }
    
    
    func postTextToFirebase(text : String) {
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        let myUID = myUser.uid
        var userName = myUser.displayName ?? myUser.email ?? "Jack Error"
        
        if let userFirstName = userName.components(separatedBy: " ").first {
            userName = userFirstName
        }
        
        
        let msgID = "\(Date().millisecondsSince1970)"
        
        let data = generateMsgDataStrip(text: text, userID: myUID, userName: userName)
        
        db.collection("Feed").document(chatID).collection("Messages").document(msgID).setData(data)
        
        
    }
    
    
    
    //MARK:- Helper Methods
    
    func generateMsgDataStrip(text : String, userID : String, userName : String) -> [String:Any] {
        
        let data = [
            "text": text,
            "userID": userID,
            "userName": userName,
            "timestamp": Date(),
            ] as [String : Any]
        //FIX: what if date local different figure uot
        return data
    }
    
    
    
}
