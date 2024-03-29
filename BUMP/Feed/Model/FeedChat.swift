//
//  FeedChat.swift
//  BUMP
//
//  Created by Hunain Ali on 12/8/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

struct FeedUser {
    var userID : String
    var isFollowing : Bool?
    var lastSeen : Timestamp?
}

class FeedChat {
    
    var chatID : String
    var circleID : String
    var circleName : String
    var circleEmoji : String
    
    var myUser : FeedUser
    var messageArray : [Message]
    
    init(chatID : String, circleID : String, circleName : String, circleEmoji : String, myUser : FeedUser, messageArray : [Message]) {
        
        self.chatID = chatID
        self.circleID = circleID
        self.circleName = circleName
        self.circleEmoji = circleEmoji
        self.myUser = myUser
        self.messageArray = messageArray
        
    }
    
    
    
    func sortMessageArray() {
        
        self.messageArray = self.messageArray.sorted { (m1, m2) -> Bool in
            if m1.timestamp.compare(m2.timestamp) == ComparisonResult.orderedAscending {
                return true
            } else {
                return false
            }
        }
        
    }
    
    func getFirstMessage() -> Message? {
        
        self.sortMessageArray()
        guard let firstMsg = self.messageArray.first else { return nil }
        
        return firstMsg
    }
    
    
    func getTimestampString() -> String {
        
        self.sortMessageArray()
        guard let firstMsg = self.getFirstMessage() else { return "🤙" }
        
        let timestampDate = firstMsg.timestamp.dateValue()
        let timestampTimeInterval = NSInteger(-timestampDate.timeIntervalSinceNow)
        let minutesAgo = (timestampTimeInterval / 60) % 60
        let hoursAgo = (timestampTimeInterval / 3600)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: timestampDate)
        
        if hoursAgo == 0 && minutesAgo == 0 {
            return "just now"
        }
        else if hoursAgo == 0 {
            return "\(minutesAgo) min ago"
        }
        else {
            return dateString
        }
        
    }
    
    
    // MARK: - MY STUFF
    
    func getMyUserUnreadMsgs() -> Int {
        
        let allMsgCount = self.messageArray.count
        
        guard let myLastSeen = myUser.lastSeen else { return allMsgCount }
        
        
        let unreadMsgs = self.messageArray.filter({ myLastSeen.compare($0.timestamp) == ComparisonResult.orderedAscending})
        
        return unreadMsgs.count
        
        
    }

    
    func isMyUserFollowing() -> Bool {
        
        guard let isFollowing = myUser.isFollowing else { return false }
        
        return isFollowing
        
    }
    
    
}
