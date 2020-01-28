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
    
    
    @objc func joinButtonTapped(sender: IndexTapGestureRecognizer)
    {
        guard let indexPath = sender.indexPath else { return }
        
        let circle = self.circleArray[indexPath.section][indexPath.row]
        
        if circle.amFollowing() {
            CircleFollower.shared.unFollowCircle(circleID: circle.circleID)
        }
        else {
            CircleFollower.shared.followCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
    }
    
    
    @objc func userImageTapped(sender: IndexTapGestureRecognizer)
    {
        guard let indexPath = sender.indexPath else { return }
        
        let circle = self.circleArray[indexPath.section][indexPath.row]
        
        CircleManager.shared.presentCircleInfo(circleID: circle.circleID, circleName: circle.circleName, circleDescription: circle.circleDescription)
    }
    
}


class IndexTapGestureRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}
