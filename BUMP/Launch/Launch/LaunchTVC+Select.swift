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
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        if indexPath.section == 0 {
            
            let circle = self.getMyCircles()[indexPath.row]
            
            CircleManager.shared.presentCircleInfo(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji, circleDescription: circle.circleDescription, memberArray: circle.memberArray)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            guard LoginManager.shared.isLoggedIn() else { return }
            
            let circle = self.getMyCircles()[indexPath.row]
            
            CircleManager.shared.launchCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
        
        if indexPath.section == 1 {
            let category = self.getCategoryArray()[indexPath.row]
            let categoryCircleArray = self.getCategoryCircleArray(category: category)
            
            let vc = CategoryTVC(style: .grouped)
            vc.title = category.stringByRemovingEmoji()
            vc.circleArray = categoryCircleArray
            vc.category = category
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    

    
    
}
