//
//  ChatLogCollectionVC+DataSource.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SwiftEntryKit

extension ChatVC {
    
    // MARK: UICollectionViewDataSource
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return msgArray.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let section = msgArray[section]
        return section.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let myUID = Auth.auth().currentUser?.uid else {
            let c = UICollectionViewCell()
            return c
        }
        
        let cellMeta = getSizeForCell(indexPath: indexPath)
        
        let msg = cellMeta.msg
        let userImageEnabled = cellMeta.isUserImageEnabled
        let userNameEnabled = cellMeta.isUserNameEnabled
        
        
        if myUID != msg.userID {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: incomingTextMessageCellID, for: indexPath) as! IncomingTextMessageCell

            cell.setupCell(message: msg, isUserImageEnabled: userImageEnabled, isUserNameEnabled: userNameEnabled)
            
            cell.userImageAction = { [unowned self] in
                self.presentUserProfileView(userID: msg.userID)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: outgoingTextMessageCellID, for: indexPath) as! OutgoingTextMessageCell
 
            cell.setupCell(message: msg)
            
            return cell
        }
    }
    
    func presentUserProfileView(userID : String) {
        
        self.inputBarView.inputTextView.resignFirstResponder()
        
        let vc = UserProfileView(userID: userID, actionButtonEnabled: false)
        let atr = Constant.bottomPopUpAttributes
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: vc, using: atr)
        }
    }
    
    
    func getSizeForCell(indexPath : IndexPath) -> (msg : Message, cellHeight : CGFloat, isUserNameEnabled : Bool, isUserImageEnabled : Bool) {
        
        let sectionIndex = indexPath.section
        let msgIndex = indexPath.item
        let section = msgArray[sectionIndex]
        let msg = section[msgIndex]
        
        let msgFrame = estimateFrameForText(msg.text, textFont: MsgCellConfig.msgFont, maxWidth: MsgCellConfig.maxBubbleWidth)
        let bubbleHeight = msgFrame.height + (MsgCellConfig.verticalBubblePadding * 2)
        
        guard let myUID = Auth.auth().currentUser?.uid else { return (msg, 0.0, false, false) }

        if myUID == msg.userID {
            let cellHeight = bubbleHeight
            return (msg, cellHeight, false, false)
        }
        
        var isUserNameEnabled = false
        if msgIndex == 0 {
            isUserNameEnabled = true
        }
        
        var isUserImageEnabled = false
        if msgIndex == section.count-1 {
            isUserImageEnabled = true
        }
        
        if isUserNameEnabled {
            let usernameFrame = estimateFrameForText(msg.userName, textFont: MsgCellConfig.msgFont, maxWidth: MsgCellConfig.maxBubbleWidth)
            let nameLabelHeight = usernameFrame.height + 0.0
            let cellHeight = nameLabelHeight + bubbleHeight
            return (msg, cellHeight, isUserNameEnabled, isUserImageEnabled)
        } else {
            let cellHeight = bubbleHeight
            return (msg, cellHeight, isUserNameEnabled, isUserImageEnabled)
        }
        
    }
    
    func insertMsgIntoMsgArray(message msg : Message) -> (indexPath : IndexPath, newSectionCreated : Bool) {
        
        var createNewGroup = false
        if msgArray.isEmpty {
            createNewGroup = true
        }
        if let lastMsgGroup = msgArray.last, let lastMsg = lastMsgGroup.last {
            if lastMsg.userID != msg.userID {
                createNewGroup = true
            }
        }
        
        if createNewGroup == true {
            let newMsgGroup = [msg]
            msgArray.append(newMsgGroup)
        }
        else {
            msgArray[msgArray.count-1].append(msg)
        }
        
        let msgSection = msgArray.count-1
        let msgItem = msgArray[msgSection].count-1
        
        return (IndexPath(item: msgItem, section: msgSection), createNewGroup)
    }
    
    
}




extension ChatVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellMeta = getSizeForCell(indexPath: indexPath)
        //
        guard let myUID = Auth.auth().currentUser?.uid else { return CGSize.zero}
        
        if cellMeta.msg.userID == myUID {
            //outgoing
            return CGSize(width: self.collectionView.frame.width - MsgCellConfig.outBubbleMargins.left - MsgCellConfig.outBubbleMargins.right, height: cellMeta.cellHeight)
        } else {
            //ingoing
            return CGSize(width: self.collectionView.frame.width - MsgCellConfig.inBubbleMargins.left - MsgCellConfig.inBubbleMargins.right, height: cellMeta.cellHeight)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 6.0, left: 0.0, bottom: 6.0, right: 0.0)
        
        guard let msg = msgArray[section].last else { return UIEdgeInsets.zero}
//
        guard let myUID = Auth.auth().currentUser?.uid else { return UIEdgeInsets.zero}
    
        if msg.userID == myUID {
            return MsgCellConfig.outBubbleMargins
        } else {
            return MsgCellConfig.inBubbleMargins
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return MsgCellConfig.bubbleSpacing
    }
    

}

