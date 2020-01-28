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
//        //OLDApproach non-exclusive everything in their category. repeated.
//        if feedChat.myUser.isFollowing ?? false {
//            self.viewControllers[0].feedChatUpdated(feedChat: feedChat)
//        } else {
//            self.viewControllers[0].feedChatRemoved(chatID: feedChat.chatID)
//        }
//
//        if feedChat.isMyCircle {
//            self.viewControllers[1].feedChatUpdated(feedChat: feedChat)
//        } else {
//            self.viewControllers[1].feedChatRemoved(chatID: feedChat.chatID)
//        }
//
//        self.viewControllers[2].feedChatUpdated(feedChat: feedChat)
        
        
        ////
        ////
        //// break
        
//        if feedChat.myUser.isFollowing ?? false {
//            self.viewControllers[1].feedChatRemoved(chatID: feedChat.chatID)
//            self.viewControllers[2].feedChatRemoved(chatID: feedChat.chatID)
//            self.viewControllers[0].feedChatUpdated(feedChat: feedChat)
//            if feedChat.getNumUnreadMessages() > 0 {
//                if let items = self.tabmanBar.items {
////                    items[0].badgeValue = "1"
//                }
//            }
//        }
//        else if feedChat.isMyCircle {
//            self.viewControllers[0].feedChatRemoved(chatID: feedChat.chatID)
//            self.viewControllers[2].feedChatRemoved(chatID: feedChat.chatID)
//            self.viewControllers[1].feedChatUpdated(feedChat: feedChat)
//            if feedChat.getNumUnreadMessages() > 0 {
////                if let items = self.tabmanBar.items {
////                    items[1].badgeValue = "1"
////                }
//            }
//        }
//        else {
//            self.viewControllers[0].feedChatRemoved(chatID: feedChat.chatID)
//            self.viewControllers[1].feedChatRemoved(chatID: feedChat.chatID)
//            self.viewControllers[2].feedChatUpdated(feedChat: feedChat)
//            if feedChat.getNumUnreadMessages() > 0 {
//                if let items = self.tabmanBar.items {
////                    items[2].badgeValue = "1"
//                }
//
//            }
//        }
        
        
        ////
        ////
        //// break
        
        if feedChat.myUser.isFollowing ?? false {
//            self.viewControllers[0].feedChatRemoved(chatID: feedChat.chatID)
            self.viewControllers[0].feedChatUpdated(feedChat: feedChat)
            self.viewControllers[1].feedChatUpdated(feedChat: feedChat)
        }
        else {
            self.viewControllers[1].feedChatRemoved(chatID: feedChat.chatID)
            self.viewControllers[0].feedChatUpdated(feedChat: feedChat)
        }
        
        
        
        
        
    }
    
    func feedChatRemoved(chatID: String) {
        for v in self.viewControllers {
            v.feedChatRemoved(chatID: chatID)
        }
    }
    
    
    
}
