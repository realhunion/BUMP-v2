//
//  UserReporterView+Action.swift
//  BUMP
//
//  Created by Hunain Ali on 11/6/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit

extension UserReporterView {
    
    @objc func reportButtonPressed() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { SwiftEntryKit.dismiss(); return }
        
        self.setUIToReporting()
        
        let data = ["timestamp" : FieldValue.serverTimestamp(),
                    "reason": self.textField.text ?? ""] as [String : Any]
        
        let ref = db.collection("Reported-Users").document(self.userID).collection("ReportedBy").document(myUID)
        ref.setData(data) { (err) in
            guard err == nil else {
                self.resetUI()
                return
            }
            
            let v = UserProfileView(userID: self.userID)
            let atr = Constant.bottomPopUpAttributes
            SwiftEntryKit.display(entry: v, using: atr)
        }
    }
    
    
    
    
    
    @objc func cancelButtonPressed() {
        
        let v = UserProfileView(userID: self.userID)
        let atr = Constant.bottomPopUpAttributes
        SwiftEntryKit.display(entry: v, using: atr)
        
    }
    
    
    func setUIToReporting() {
        
        self.reportButton.isEnabled = false
        
        self.reportButton.setTitle("Reporting User...", for: .normal)
        
    }
    
    
    func resetUI() {
        
        self.reportButton.isEnabled = true
        
        self.reportButton.setTitle("Report User", for: .normal)
        self.reportButton.setTitle("Block User", for: .normal)
        
    }
    
    
    
}
