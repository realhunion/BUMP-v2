//
//  LoginVerifier.swift
//  BUMP
//
//  Created by Hunain Ali on 11/8/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftEntryKit
import QuickLayout

class LoginManager {
    
    
    static let shared = LoginManager()
    
    func isLoggedIn() -> Bool {
        
        guard let user = Auth.auth().currentUser else {
            self.presentSignupVC()
            return false
        }
        
        if user.isEmailVerified == false {
            self.presentLoginVC(email: user.email)
            return false
        }
        else if user.photoURL == nil {
            self.presentUserProfileEditView(userName: user.displayName, userHandle: user.email)
            return false
        }
        else {
            return true
        }
    }
    
    
    func presentLoginVC(email : String? = nil, pass: String? = nil) {
        
        let v = LoginView()
        v.emailTextField.text = email
        v.passTextField.text = pass
        
        var atr = Constant.centerPopUpAttributes
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        SwiftEntryKit.display(entry: v, using: atr)
        
    }
    
    func presentSignupVC() {
        
        let view = SignupView()
        
        var atr = Constant.centerPopUpAttributes
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        SwiftEntryKit.display(entry: view, using: atr)
        
    }
    
    func presentUserProfileEditView(userName : String?, userHandle : String?) {
        
        guard let myUID = Auth.auth().currentUser?.uid else {
            
            self.presentSignupVC()
            return
            
        }
        
        let view = UserProfileEditView(userID: myUID, userImage: nil, userName: userName, userHandle: userHandle, userDescription: nil)
        
        var atr = Constant.bottomPopUpAttributes
        atr.entryInteraction = .absorbTouches
        atr.screenInteraction = .absorbTouches
        atr.scroll = .disabled
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        SwiftEntryKit.display(entry: view, using: atr)
        
        
        
    }
    
    
    
    
}
