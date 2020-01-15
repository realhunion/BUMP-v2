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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCircleUnLaunched()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.inputBarView.inputTextView.becomeFirstResponder()
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
    
    override func setupCollectionView() {
        super.setupCollectionView()
        self.collectionView.isScrollEnabled = false
        
        self.inputBarView.inputTextView.placeholder = "Send a message to Launch Circle"
    }
    
    
    //MARK: - Navigattion Buttons
    
    override func backButtonTapped() {
        self.dismiss(animated: true) {}
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
    
    
    
    //MARK: - LAUNCH FLOW
    
    func setCircleUnLaunched() {
        self.followChatButton.isHidden = true
    }
    
    func setCircleLaunched() {
        self.chatFollower.followChat()
        //dependsFIX: depedns if setting enabled in settings.
        
        self.followChatButton.isSelected = true
        self.followChatButton.isHidden = false
    }
    
    
}
