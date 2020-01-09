//
//  ChatVC+MessagesFetcherDelegate.swift
//  OASIS2
//
//  Created by Honey on 5/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase


extension ChatVC : MessageFetcherDelegate {
    
    
    func newMessagesAdded(messages: [Message], initialLoadDone : Bool) {
        
        if !initialLoadDone {
            
            //sort by order timestamp
            let msgs = messages.sorted { (m1, m2) -> Bool in
                if m1.timestamp.compare(m2.timestamp) == .orderedAscending {
                    return true
                } else {
                    return false
                }
            }
            for m in msgs {
                let _ = self.insertMsgIntoMsgArray(message: m)
            }
            DispatchQueue.main.async {
                //FIX: speed it up
                UIView.transition(with: self.collectionView,
                                  duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: { self.collectionView.reloadData() })
                
                self.scrollToBottom(at: .bottom, isAnimated: false)
                self.inputBarView.isUserInteractionEnabled = true
            }
            
        } else {
            
            
            if self.inputBarView.isUserInteractionEnabled == false { return }
            
            self.collectionView.performBatchUpdates({
                
                for m in messages {
                    
                    let x = self.insertMsgIntoMsgArray(message: m)
                    let indexPath = x.indexPath
                    let newSectionCreated = x.newSectionCreated
                    
                    //refresh last cell
                    if newSectionCreated {
                        self.collectionView?.insertSections([indexPath.section])
                    } else {
                        self.collectionView?.insertItems(at: [indexPath])
                    }
                    
                    //refresh 2nd last cell also
                    if indexPath.item-1 >= 0 {
                        self.collectionView?.reloadItems(at: [IndexPath (item: indexPath.item - 1, section: indexPath.section)])
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.scrollToBottom(at: .bottom, isAnimated: true)
                }
                
            }, completion: { (isDone) in })
        }
    }
    
}
