//
//  FeedTabVC+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 1/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit

extension FeedTabVC : FeedFetcherDelegate {
    
    func setupFeedFetcher() {
        self.feedFetcher = FeedFetcher()
        self.feedFetcher?.startMonitor()
        self.feedFetcher?.delegate = self
    }
    
    
    func feedChatUpdated(feedChat: FeedChat) {

        
        if feedChat.isMyUserFollowing() {
            self.viewControllers[1].feedChatUpdated(feedChat: feedChat)
        }
        else {
            self.viewControllers[1].feedChatRemoved(chatID: feedChat.chatID)
        }
        
        self.viewControllers[0].feedChatUpdated(feedChat: feedChat)
        
    }
    
    
    func feedChatRemoved(chatID: String) {
        for v in self.viewControllers {
            v.feedChatRemoved(chatID: chatID)
        }
    }
    
    
    
}
