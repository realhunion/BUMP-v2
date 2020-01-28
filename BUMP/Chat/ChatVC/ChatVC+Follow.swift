//
//  ChatVC+Follow.swift
//  BUMP
//
//  Created by Hunain Ali on 1/7/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation

extension ChatVC : MyChatFollowFetcherDelegate {
    
    func setupChatFollower() {
        self.myChatFollowFetcher = MyChatFollowFetcher(chatID: self.chatID)
        self.myChatFollowFetcher?.delegate = self
        self.myChatFollowFetcher?.monitorMyFollow()
    }
    
    func chatFollowUpdated(isFollowing: Bool) {
        
        self.followChatButton.isSelected = isFollowing
        
        
    }
    
    
    
    @objc func followChatButtonTapped() {
        
        CircleManager.shared.updateFeedLastSeen(chatID: self.chatID)
        if !self.followChatButton.isSelected {
            ChatFollower.shared.followChat(chatID: self.chatID)
        }
        else {
            ChatFollower.shared.unFollowChat(chatID: self.chatID)
        }
        
    }
    
    
    
    
}
