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
        
        if indexPath.section == 0 {
            let circle = self.getMyCircles()[indexPath.row]
            CircleManager.shared.presentCircleInfo(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji, circleDescription: circle.circleDescription, memberArray: circle.memberArray)
        }
        
        if indexPath.section == 1 {
            let circle = self.getRestCircles()[indexPath.row]
            CircleManager.shared.presentCircleInfo(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji, circleDescription: circle.circleDescription, memberArray: circle.memberArray)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        if indexPath.section == 0 {
            let circle = self.getMyCircles()[indexPath.row]
            CircleManager.shared.launchCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
        
        if indexPath.section == 1 {
            let circle = self.getRestCircles()[indexPath.row]
//            CircleManager.shared.launchCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
            self.presentJoinAlert(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
        
    }
    
    
    
    @objc func joinButtonTapped(sender: IndexTapGestureRecognizer)
    {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        guard let indexPath = sender.indexPath else { return }
        
        if indexPath.section == 0 {
            let circle = self.getMyCircles()[indexPath.row]
            CircleFollower.shared.unFollowCircle(circleID: circle.circleID)
        }
        
        if indexPath.section == 1 {
            let circle = self.getRestCircles()[indexPath.row]
            CircleFollower.shared.followCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
        
    }
    
    
    //MARK: Tool
    
    
    func presentJoinAlert(circleID : String, circleName : String, circleEmoji : String) {
        
        let alert = UIAlertController(title: "\(circleName)", message: "Join to be able to send & view messages in chats.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let joinAction = UIAlertAction(title: "Join Groupchat", style: .default) { (action) in
            CircleFollower.shared.followCircle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        }
        
        alert.addAction(joinAction)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
}
