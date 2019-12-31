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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func updateFeedLastSeen() {
        guard let msgSndr = self.msgSender as? LaunchMessageSender else { return }
        print("called sir")
        if msgSndr.isLaunched {
            print("called sir u2")
            super.updateFeedLastSeen()
        }
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
    
    
    
    
    
}
