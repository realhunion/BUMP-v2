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
    
    
    
    func presentIntroInfo() {
        
        let vc = IntroInfoVC()
        vc.title = "Bump: A Run Down"
        let nvc = UINavigationController(rootViewController: vc)
        
        nvc.modalPresentationStyle = .pageSheet
        nvc.presentationController?.delegate = vc
        if #available(iOS 13.0, *) {
            nvc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        DispatchQueue.main.async {
            self.present(nvc, animated: true, completion: nil)
        }
        
    }
    
    
    func presentMyProfile() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let vc = UserProfileView(userID: myUID, actionButtonEnabled: true)
        let atr = Constant.bottomPopUpAttributes
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: vc, using: atr)
        }
        
    }
    
    func presentMyCircles() {
        
        let vc = MyCirclesTVC()
        vc.title = "Tap to Join / Leave"
        
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                let nvc = UINavigationController(rootViewController: vc)
                nvc.navigationBar.prefersLargeTitles = false
                vc.modalPresentationStyle = .pageSheet
                vc.modalPresentationCapturesStatusBarAppearance = true
                
                self.present(nvc, animated: true, completion: nil)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
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
        
        alert.addAction(silence1h)
        alert.addAction(silence3h)
        alert.addAction(silence12h)
        alert.addAction(unsilence)
        
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
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
//        vc.edgesForExtendedLayout = []

        if let rtfPath = Bundle.main.url(forResource: "Credits", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)

                let infoView = InfoTextView(text: "Credits")
                infoView.textView.attributedText = attributedStringWithRtf
                vc.view.addSubview(infoView)
                infoView.frame = vc.view.frame
                vc.title = "Credits"

            } catch let error {
                print("Got an error \(error)")
            }
        }

        DispatchQueue.main.async {
//            let nvc = UINavigationController(rootViewController: vc)
//            nvc.modalPresentationStyle = .pageSheet
//            SwiftEntryKit.display(entry: nvc, using: Constant.fixedPopUpAttributes(heightWidthRatio: 0.9))
//            self.present(nvc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func presentTerms() {
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.edgesForExtendedLayout = []
        
        if let rtfPath = Bundle.main.url(forResource: "TermsAndConditions", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                
                let infoView = InfoTextView(text: "Privacy")
                infoView.textView.attributedText = attributedStringWithRtf
                vc.view.addSubview(infoView)
                infoView.frame = self.view.frame
                vc.title = "Rules of Bumpland"
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
        
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: vc, using: Constant.fixedPopUpAttributes(heightWidthRatio: 0.9))
        }
    }
    
    
}
