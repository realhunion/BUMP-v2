//
//  LaunchTVC+Follow.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

extension LaunchTVC {
    
    
    
    @objc func tappedFollowButton(sender: IndexTapGestureRecognizer)
    {
        guard let indexPath = sender.indexPath else { return }
        
        let circle = self.circleArray[indexPath.section][indexPath.row]
        
        if circle.amFollowing() {
            CircleFollower.shared.unFollowCircle(circleID: circle.circleID)
        }
        else {
            CircleFollower.shared.followCircle(circleID: circle.circleID)
        }
    }
    
    
}


class IndexTapGestureRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}
