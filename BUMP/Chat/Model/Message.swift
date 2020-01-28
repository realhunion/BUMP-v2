//
//  Message.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    var userID : String
    var userName : String
    var text : String
    var timestamp : Timestamp
    
    init(userID : String, userName : String, text : String, timestamp : Timestamp) {
        self.userID = userID
        self.userName = userName
        self.text = text
        self.timestamp = timestamp
    }
    
    
    
    
}
