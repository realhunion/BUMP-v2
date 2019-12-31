//
//  ChatVC+MsgSender.swift
//  OASIS2
//
//  Created by Honey on 5/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//import SwiftEntryKit

extension ChatVC {
    
    @objc func handleHeyButton() {
        
        self.sendTextMessage(text: "🤙")
        
    }
    
    @objc func handleSend() {
        
        
        guard let text = inputBarView.inputTextView.text else { return }
        
        inputBarView.prepareForSend()
        
        self.sendTextMessage(text: text)
        
    }
    
    
    func sendTextMessage(text : String) {
        
        let formattedText = text.trimmingCharacters(in: .whitespaces)
        
        self.msgSender.sendMsg(text: formattedText)
        
        
        
    }
    
    
    
    
    
    
    
    // MARK: - Screen Tap Gestures
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    @objc func screenTapped() {
        if self.inputBarView.inputTextView.isFirstResponder {
            self.inputBarView.inputTextView.resignFirstResponder()
        }
        else {
            self.inputBarView.inputTextView.becomeFirstResponder()
        }
        
    }
    
    
    
    
    
    
    
    //MARK: - Keyboard & Content Offset & Constraints Movement
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0
        
        inputBarBottomAnchor?.constant = -keyboardFrame!.height + view.safeAreaInsets.bottom
        collectionView?.contentInset = UIEdgeInsets(top: 44+47+10, left: 0, bottom: self.inputBarHeight + 10, right: 0)
        
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom(at: .bottom, isAnimated: true)
        }, completion: { (completed) in})
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0
        
        inputBarBottomAnchor?.constant = 0
        collectionView?.contentInset = UIEdgeInsets(top: 44+47+10, left: 0, bottom: 10, right: 0)
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom(at: .bottom, isAnimated: true)
        }, completion: { (completed) in})
    }
    
    
    
}
