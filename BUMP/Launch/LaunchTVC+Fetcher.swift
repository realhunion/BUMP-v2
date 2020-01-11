//
//  LaunchTVC+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation



extension LaunchTVC : LaunchFetcherDelegate {
    

    func insertLaunchCircle(launchCircle : LaunchCircle) {
        var section = 0
        if !launchCircle.amFollowing() {
            section = 1
        }
        
        self.circleArray[section].append(launchCircle)
        
        self.sortCircleArray()
    }
    
    func deleteLaunchCircle(circleID : String) {
        
        for section in 0..<self.circleArray.count {
            
            self.circleArray[section].removeAll(where: {$0.circleID == circleID})
            
        }
    }
    
    
    
    
    
    func launchCircleUpdated(circleID: String, launchCircle: LaunchCircle) {
        
        self.deleteLaunchCircle(circleID: circleID)
        self.insertLaunchCircle(launchCircle: launchCircle)
        
        self.tableView.reloadData()
    }
    
    func launchCircleRemoved(circleID: String) {
        
        self.deleteLaunchCircle(circleID: circleID)
        
        self.tableView.reloadData()
        
    }
    
    
}
