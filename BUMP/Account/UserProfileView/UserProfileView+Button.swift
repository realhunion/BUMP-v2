//
//  UserProfileView+Button.swift
//  BUMP
//
//  Created by Hunain Ali on 11/6/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit

extension UserProfileView {
    
    
    @objc func optionsButtonPressed() {
        
        let v = UserReporterView(userID: self.userID, userName: self.userNameLabel.text ?? "user")
        var atr = Constant.centerPopUpAttributes
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: v, using: atr)
        }
        
    }
    
    
    @objc func actionButtonPressed() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        guard let uProfile = self.userProfile else { return }
        
        print("oprah")
        
        if self.userID == myUID {
            let v = UserProfileEditView(userID: uProfile.userID, userImage: self.userImageView.image, userName: uProfile.userName, userHandle: uProfile.userHandle, userDescription: uProfile.userDescription)
            var atr = Constant.bottomPopUpAttributes
            let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
            let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
            atr.positionConstraints.keyboardRelation = keyboardRelation
            
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: v, using: atr)
            }
            
        }
        
    }
    
}


