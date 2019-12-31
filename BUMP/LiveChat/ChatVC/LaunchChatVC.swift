//
//  LaunchChatVC.swift
//  BUMP
//
//  Created by Hunain Ali on 12/16/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase

class LaunchChatVC : ChatVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.inputBarView.inputTextView.becomeFirstResponder()
    }
    
    //MARK: - Setup
    
    override func setupMessageSender() {
        self.msgSender = LaunchMessageSender(chatID: self.chatID, circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji)
    }
    
    override func setupCollectionView() {
        super.setupCollectionView()
        self.collectionView.isScrollEnabled = false
    }
    
    
    //MARK: - Navigattion Buttons
    
    override func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    override func followChatButtonTapped() {
        self.followChatButton.isSelected = !self.followChatButton.isSelected
        //FIX: 
    }
    
    
    
    // MARK: - Send a Message
    
    @objc override func handleSend() {
        guard let text = inputBarView.inputTextView.text else { return }
        
        inputBarView.prepareForSend()
        
        self.msgSender.sendMsg(text: text)
    }
    
    
    
}
