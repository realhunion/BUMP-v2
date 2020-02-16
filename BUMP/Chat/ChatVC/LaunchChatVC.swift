//
//  LaunchChatVC.swift
//  BUMP
//
//  Created by Hunain Ali on 12/16/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase
import QuickLayout

class LaunchChatVC : ChatVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    override func updateFeedMsgsRead() {
        guard let msgSndr = self.msgSender as? LaunchMessageSender else { return }
        guard msgSndr.isLaunched else { return }
        
        super.updateFeedMsgsRead()
    }
    
    
    //MARK: - Setup
    
    override func setupMessageSender() {
        self.msgSender = LaunchMessageSender(chatID: self.chatID, circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji)
    }
    
    
    
    
    //MARK: - Button Actions
    
    override func followChatButtonTapped() {
        guard let msgSndr = self.msgSender as? LaunchMessageSender else { return }
        guard msgSndr.isLaunched else { return }
        
        super.followChatButtonTapped()
    }
    
    override func handleSend() {
        guard let msgSndr = self.msgSender as? LaunchMessageSender else { return }
        
        if !msgSndr.isLaunched {
            self.setCircleLaunched()
        }
        
        super.handleSend()
        
    }
    
    override func handleHeyButton() {
        guard let msgSndr = self.msgSender as? LaunchMessageSender else { return }
        
        if !msgSndr.isLaunched {
            self.setCircleLaunched()
        }
        
        super.handleHeyButton()
        
    }
    
    
    
    //MARK: - LAUNCH FLOW
    
    func setCircleLaunched() {
        ChatFollower.shared.followChat(chatID: self.chatID)
        //dependsFIX: depedns if setting enabled in settings.
        
        self.followChatButton.isSelected = true
        self.followChatButton.isHidden = false
    }
    
    
}
