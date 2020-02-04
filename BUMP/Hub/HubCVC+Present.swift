//
//  HubCVC+Silence.swift
//  BUMP
//
//  Created by Hunain Ali on 1/5/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SwiftEntryKit
import SPStorkController

extension HubCVC {
    
    
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
        
        
        UIApplication.topViewController()?.dismiss(animated: false) {}
        UIApplication.topViewController()?.present(nvc, animated: true) {}
        
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
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let vc = MyCirclesTVC()
        vc.title = "Tap to Join / Leave"
        
        vc.modalPresentationStyle = .pageSheet
        vc.modalPresentationCapturesStatusBarAppearance = true
        
        let nvc = UINavigationController(rootViewController: vc)
        
        self.present(nvc, animated: true) {}
        
    }
    
    
    
    func presentSilenceMenu() {
        
        SilenceManager.shared.presentSilenceMenu()
    
    }
    
    
    func presentHelpline() {
        
        let email = "limjames@grinnell.edu"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    
    
}
