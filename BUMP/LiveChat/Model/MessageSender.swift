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
        print("crr0")
        self.postTextToFirebase(text: text)
    }
    
    
    func postTextToFirebase(text : String) {
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        let myUID = myUser.uid
        var userName = myUser.displayName ?? myUser.email ?? "Jack Error"
        
        if let userFirstName = userName.components(separatedBy: " ").first {
            userName = userFirstName
        }
        
        
        let timestamp = generateUniqueTimestamp()
        
        let data = generateMsgDataStrip(text: text, userID: myUID, userName: userName)
        
        db.collection("Feed").document(chatID).collection("Messages").document(timestamp).setData(data)
        
        
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
    
    func generateUniqueTimestamp() -> String {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "MMddHHmmssSSS"
        let timestamp = df.string(from: d)
        df.timeStyle = .medium
        let timestamp2 = df.string(from: d)
        let finalTimestamp = numCharConversion(theString: timestamp) + " " + timestamp2
        // -> zxysyxuuzvusw 12:55:04 PM
        return finalTimestamp
    }
    
    func numCharConversion(theString : String) -> String {
        var s = theString
        s = s.replacingOccurrences(of: "0", with: "z")
        s = s.replacingOccurrences(of: "1", with: "y")
        s = s.replacingOccurrences(of: "2", with: "x")
        s = s.replacingOccurrences(of: "3", with: "w")
        s = s.replacingOccurrences(of: "4", with: "v")
        s = s.replacingOccurrences(of: "5", with: "u")
        s = s.replacingOccurrences(of: "6", with: "t")
        s = s.replacingOccurrences(of: "7", with: "s")
        s = s.replacingOccurrences(of: "8", with: "r")
        s = s.replacingOccurrences(of: "9", with: "q")
        return s
    }
    
    
    
}
