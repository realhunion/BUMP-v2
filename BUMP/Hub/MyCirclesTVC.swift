//
//  FollowModeTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 1/11/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit

class MyCirclesTVC : LaunchTVC {
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let c = circleArray[indexPath.section][indexPath.row]
        
        cell.detailTextLabel?.text = "\(c.followerIDArray.count) members"
        cell.detailTextLabel?.textColor = UIColor.darkGray
        
        if c.amFollowing() {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        return cell
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let circle = circleArray[indexPath.section][indexPath.row]
        
        if circle.amFollowing() {
            CircleFollower.shared.unFollowCircle(circleID: circle.circleID)
        }
        else {
            CircleFollower.shared.followCircle(circleID: circle.circleID)
        }
    }
    
}
