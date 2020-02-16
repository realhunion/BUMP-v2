//
//  CategoryTVC+Select.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

extension CategoryTVC {
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard LoginManager.shared.isLoggedIn() else { return }
        
        let circle = self.circleArray[indexPath.section][indexPath.row]
        
        CircleManager.shared.presentCircleInfo(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji, circleDescription: circle.circleDescription, memberArray: circle.memberArray)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        let circle = circleArray[indexPath.section][indexPath.row]
        
        CircleManager.shared.launchCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        
    }
    
    
    
    @objc func joinButtonTapped(sender: IndexTapGestureRecognizer)
    {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        guard let indexPath = sender.indexPath else { return }
        
        let circle = self.circleArray[indexPath.section][indexPath.row]
        
        if !circle.amMember() {
            CircleFollower.shared.followCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        } else {
            CircleFollower.shared.unFollowCircle(circleID: circle.circleID)
//            self.tableView(self.tableView, didSelectRowAt: indexPath)
        }
        //FIX: currently only does for not joined in. join em.
    }
    
    
    
    
    
}
