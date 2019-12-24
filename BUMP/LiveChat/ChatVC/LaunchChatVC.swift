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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.inputBarView.inputTextView.becomeFirstResponder()
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
        
    }
    
    
    
    // MARK: - Send a Message
    
    var launchMsgSent = false
    
    @objc override func handleSend() {
        guard let text = inputBarView.inputTextView.text else { return }
        
        inputBarView.prepareForSend()
        
        if launchMsgSent {
            
            self.sendTextMessage(text: text)
        } else {
            
            self.sendLaunchTextMessage(text: text)
            self.launchMsgSent = true
        }
    }
    
    func sendLaunchTextMessage(text : String) {
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.msgSender?.postLaunchTextToFirebase(text: trimmedText)
        
    }
    
    
}
