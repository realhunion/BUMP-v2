//
//  UnreadFeedCell.swift
//  BUMP
//
//  Created by Hunain Ali on 12/23/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import UIKit

class UnreadFeedCell : FeedCell {
    
    
    var newMessagesLabel : InsetLabel = {
        let label = InsetLabel()
        label.adjustsFontSizeToFitWidth = true
        label.contentInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        label.backgroundColor = UIColor.systemPink
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        
        label.layer.cornerRadius = 20.0 / 2
        label.layer.masksToBounds = true
        
        return label
    }()
    
    
    override func layoutCell() {
        
        cardContentView.addSubview(followButton)
        followButton.layoutToSuperview(.top, offset: 0)
        followButton.layoutToSuperview(.left, offset: 0)
        followButton.set(.height, of: 20.0)
        
        
        cardContentView.addSubview(newMessagesLabel)
        newMessagesLabel.layoutToSuperview(.top, offset: 0)
        newMessagesLabel.set(.width, of: 20.0)
        newMessagesLabel.set(.height, of: 20.0)
        newMessagesLabel.layoutToSuperview(.right, offset: 0)
        
        cardContentView.addSubview(timeLabel)
        timeLabel.layoutToSuperview(.top, offset: 0)
        timeLabel.layout(.right, to: .left, of: newMessagesLabel, offset: -10)
        timeLabel.set(.height, of: 20.0)
        
        
        cardContentView.addSubview(circleTitleLabel)
        circleTitleLabel.layout(.top, to: .bottom, of: followButton, offset: 2)
        circleTitleLabel.layout(.top, to: .bottom, of: timeLabel, offset: 2)
        circleTitleLabel.layout(.top, to: .bottom, of: newMessagesLabel, offset: 2)
        circleTitleLabel.layoutToSuperview(.left, offset: 0)
        circleTitleLabel.layoutToSuperview(.right, offset: 0)
        
        
        cardContentView.addSubview(firstMessageLabel)
        firstMessageLabel.layout(.top, to: .bottom, of: circleTitleLabel, offset: 2)
        firstMessageLabel.layoutToSuperview(.left, offset: 0)
        firstMessageLabel.layoutToSuperview(.right, offset: 0)
        firstMessageLabel.layoutToSuperview(.bottom, offset: 0)
        
        cardView.addSubview(cardContentView)
        cardContentView.layoutToSuperview(.top, offset: 12) // 10
        cardContentView.layoutToSuperview(.bottom, offset: -16) //-15
        cardContentView.layoutToSuperview(.left, offset: 20) //20
        cardContentView.layoutToSuperview(.right, offset: -20) //-20
        
        self.contentView.addSubview(cardView)
        cardView.layoutToSuperview(.top, offset: 12) //15
        cardView.layoutToSuperview(.bottom, offset: -12) //-15
        cardView.layoutToSuperview(.left, offset: 24) //20
        cardView.layoutToSuperview(.right, offset: -24) //-20
    }
    
    
}
