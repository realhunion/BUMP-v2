//
//  HubTVC+Present.swift
//  BUMP
//
//  Created by Hunain Ali on 2/4/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import SwiftEntryKit
import UIKit
import Firebase

extension HubTVC {
    
    
    func presentMyProfile() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let vc = UserProfileView(userID: myUID, actionButtonEnabled: true)
        let atr = Constant.bottomPopUpAttributes
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: vc, using: atr)
        }
        
    }
    
    
    
    func presentSilenceMenu() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let alert = UIAlertController(title: "Silence for:", message: "You will recieve no notifications for time picked.", preferredStyle: .alert)
        
        // Create the actions
        let silence12h = UIAlertAction(title: "12 hours", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            let t = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
            var data : [String : Any] = [:]
            data["silenceUntil"] = t
            db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
            }
            
        }
        let silence3h = UIAlertAction(title: "3 hours", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            let t = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
            var data : [String : Any] = [:]
            data["silenceUntil"] = t
            db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
            }
            
        }
        let silence1h = UIAlertAction(title: "1 hour", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            let t = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            var data : [String : Any] = [:]
            data["silenceUntil"] = t
            db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
            }
        }
        let unsilence = UIAlertAction(title: "Unsilence", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            var data : [String : Any] = [:]
            data["silenceUntil"] = FieldValue.delete()
            db.collection("User-Base").document(myUID).updateData(data) { (err) in
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        
        alert.addAction(silence1h)
        alert.addAction(silence3h)
        alert.addAction(silence12h)
        alert.addAction(unsilence)
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func presentHelpline() {
        
        let email = "limjames@grinnell.edu"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    
    func presentCredits() {
        
        let vc = CreditsInfoVC()
        vc.title = "Credits"
        let nvc = UINavigationController(rootViewController: vc)
        
        nvc.modalPresentationStyle = .pageSheet
        nvc.presentationController?.delegate = vc
        if #available(iOS 13.0, *) {
            nvc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: false) {}
            self.present(nvc, animated: true) {}
        }
        
    }
    
    
    func presentTerms() {
        
        let vc = TermsInfoVC()
        vc.title = "Rules of Bumpland"
        let nvc = UINavigationController(rootViewController: vc)
        
        nvc.modalPresentationStyle = .pageSheet
        nvc.presentationController?.delegate = vc
        if #available(iOS 13.0, *) {
            nvc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: false) {}
            self.present(nvc, animated: true) {}
        }
    }
    
    
    func presentWhatIsBump() {
        
        let vc = IntroInfoVC()
        vc.title = "What is Bump?"
        let nvc = UINavigationController(rootViewController: vc)
        
        nvc.modalPresentationStyle = .pageSheet
        nvc.presentationController?.delegate = vc
        if #available(iOS 13.0, *) {
            nvc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: false) {}
            self.present(nvc, animated: true) {}
        }
    }
    
    
    func presentHowToUse() {
        
        let vc = HowToUseInfoVC()//FIX: FUTURE custom whatisBump ting.
        vc.title = "How To Use"
        let nvc = UINavigationController(rootViewController: vc)
        
        nvc.modalPresentationStyle = .pageSheet
        nvc.presentationController?.delegate = vc
        if #available(iOS 13.0, *) {
            nvc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: false) {}
            self.present(nvc, animated: true) {}
        }
    }
    
    func presentSendASuggestion() {
        
        let c = SendSuggestionView()
        
        var atr = Constant.centerPopUpAttributes
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        DispatchQueue.main.async {
            
            SwiftEntryKit.display(entry: c, using: atr)
        }
    }
    
    
}
