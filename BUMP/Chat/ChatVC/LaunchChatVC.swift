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
    
    override func setupInputBar() {
        super.setupInputBar()
//        self.inputBarView.emojiButton.setTitle("🤙", for: .normal)
        
//        self.inputBarView.inputTextView.placeholder = "Send a message to launch"
        
//        let v = UIView()
////        v.text = "Send a message to launch circle"
//        v.backgroundColor = UIColor.systemPink.withAlphaComponent(0.22)
//        let gradient = CAGradientLayer()
//
//        gradient.frame = collectionView.bounds
//        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
//
//        v.layer.insertSublayer(gradient, at: 0)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        self.collectionView.backgroundView = v
    }
    
    override func setupMessageSender() {
        self.msgSender = LaunchMessageSender(chatID: self.chatID, circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji)
    }
    
    override func setupCollectionView() {
        super.setupCollectionView()
        self.collectionView.isScrollEnabled = false
        
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
    
    override func handleHeyButton() {
        guard let msgSndr = self.msgSender as? LaunchMessageSender else { return }
        
        if !msgSndr.isLaunched {
            self.setCircleLaunched()
        }
        
        super.handleHeyButton()
        
        
    }
    
    
    
    //MARK: - LAUNCH FLOW
    
    func setCircleUnLaunched() {
        self.followChatButton.isHidden = true
    }
    
    func setCircleLaunched() {
        ChatFollower.shared.followChat(chatID: self.chatID)
        //dependsFIX: depedns if setting enabled in settings.
        
        self.followChatButton.isSelected = true
        self.followChatButton.isHidden = false
    }
    
    
}
