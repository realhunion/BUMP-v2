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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        let circle = circleArray[indexPath.section][indexPath.row]
        
        CircleManager.shared.launchCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        
    }
    
    
    
    @objc func joinButtonTapped(sender: IndexTapGestureRecognizer)
    {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        guard let indexPath = sender.indexPath else { return }
        
        let circle = self.circleArray[indexPath.section][indexPath.row]
        
        if circle.amFollowing() {
            CircleFollower.shared.unFollowCircle(circleID: circle.circleID)
        }
        else {
            CircleFollower.shared.followCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
    }
    
    
    @objc func launchEmojiTapped(sender: IndexTapGestureRecognizer)
    {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        guard let indexPath = sender.indexPath else { return }
        
        let circle = self.circleArray[indexPath.section][indexPath.row]
        
        CircleManager.shared.presentCircleInfo(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji, circleDescription: circle.circleDescription, memberArray: circle.memberArray)
    }
    
}
