//
//  ChatVC+Follow.swift
//  BUMP
//
//  Created by Hunain Ali on 1/7/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation

extension ChatVC : ChatFollowerDelegate {
    
    func setupChatFollower() {
        self.chatFollower = ChatFollower(chatID: self.chatID)
        self.chatFollower.delegate = self
        self.chatFollower.monitorMyFollow()
    }
    
    func chatFollowUpdated(isFollowing: Bool) {
        
        self.followChatButton.isSelected = isFollowing
        
    }
    
    //
    
    @objc func followChatButtonTapped() {
        
        if !self.followChatButton.isSelected {
            self.chatFollower.followChat()
        }
        else {
            self.chatFollower.unFollowChat()
        }
        
        CircleManager.shared.updateFeedRead(chatID: chatID)
        
    }
    
    
    
    
}
