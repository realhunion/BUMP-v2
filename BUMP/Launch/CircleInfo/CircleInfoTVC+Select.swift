//
//  CircleInfoTVC+Select.swift
//  BUMP
//
//  Created by Hunain Ali on 2/20/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import SwiftEntryKit
import UIKit
import Firebase

extension CircleInfoTVC {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.sections[indexPath.section] == .members {
            let user = self.memberProfileArray[indexPath.row]
            
            let vc = UserProfileView(userID: user.userID, actionButtonEnabled: false)
            let atr = Constant.bottomPopUpAttributes
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: vc, using: atr)
            }
        }
            
        else if self.sections[indexPath.section] == .options {
            guard let myUID = Auth.auth().currentUser?.uid else { return }
            if self.tableView(tableView, cellForRowAt: indexPath).textLabel?.text == "Join" {
                
                NotificationManager.shared.isEnabled { (isEnabled) in
                    guard isEnabled else { return }
                    CircleFollower.shared.followCircle(circleID: self.circleID, circleName: self.circleName, circleEmoji: self.circleEmoji)
                    DispatchQueue.main.async {
                        self.circleMemberArray.append(LaunchMember(userID: myUID, notifsOn: true))
                        self.refreshCircleMembersFetcher()
                    }
                    
                }
                
            }
            else if self.tableView(tableView, cellForRowAt: indexPath).textLabel?.text == "Leave" {
                
                CircleFollower.shared.unFollowCircle(circleID: self.circleID)
                DispatchQueue.main.async {
                    self.memberProfileArray.removeAll(where: {$0.userID == myUID})
                    self.circleMemberArray.removeAll(where: {$0.userID == myUID})
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
    
    
}
