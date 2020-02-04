//
//  CircleInfoTVC+Setup.swift
//  BUMP
//
//  Created by Hunain Ali on 1/29/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase



extension CircleInfoTVC : CircleMembersFetcherDelegate {
    
    
    func circleMembersFetched(profileArray: [UserProfile]) {
        
        self.sections.append(.members)
        self.memberProfileArray = profileArray
        
        self.tableView.reloadData()
    }
    
    
    
}


extension CircleInfoTVC {
    
    
    //Switch
    
    @objc func notificationsToggled(_ sender : UISwitch!) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        if sender.isOn {
            
            CircleFollower.shared.followCircle(circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji, notifsOn: true)
            
        } else {
            
            CircleFollower.shared.followCircle(circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji, notifsOn: false)
            
        }
        
        
    }
    

    
    
    
    
    
    
    
}
