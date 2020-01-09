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
        
        self.setupBackgroundView()
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
    }
    
    func setupBackgroundView() {
        
//        let backgroundView = UIView()
//        self.collectionView.addSubview(backgroundView)
//        backgroundView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
//
//        backgroundView.layoutToSuperview(.top, offset: 0)
//        backgroundView.layoutToSuperview(.bottom, offset: 0)
//        backgroundView.layoutToSuperview(.left, offset: 0)
//        backgroundView.layoutToSuperview(.right, offset: 0)
        
        let v = UILabel()
        collectionView.addSubview(v)
        
        v.layoutToSuperview(.centerX)
        v.layoutToSuperview(.centerY)
        
        v.text = "Send a msg to launch"
        v.font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
        
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
