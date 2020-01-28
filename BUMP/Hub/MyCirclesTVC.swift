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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDoneButton()
    }
    
    func setupDoneButton() {
        let btn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.setRightBarButton(btn, animated: true)
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
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
            CircleFollower.shared.followCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
    }
    
}
