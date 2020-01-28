//
//  UserProfileView+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 11/6/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FirebaseUI

extension UserProfileView : UserProfileFetcherDelegate {
    
    
    func userProfileUpdated(userID: String, userProfile: UserProfile) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.userProfile = userProfile
        
        let imageRef = self.storageRef.reference(withPath: userProfile.userImage)
        let placeHolder = UIImage(color: Constant.oGray)
        self.userImageView.sd_setImage(with: imageRef, placeholderImage: placeHolder)
        
        self.userHandleLabel.text = userProfile.userHandle
        
        self.userNameLabel.text = userProfile.userName
        
        self.userDescriptionLabel.text = userProfile.userDescription
        
        
        if userID != myUID {
            self.optionsButton.isHidden = false
            self.optionsButton.isEnabled = true
        }
        
        self.actionButton.isEnabled = true
        
    }
    
}
