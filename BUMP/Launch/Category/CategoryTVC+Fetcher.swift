//
//  CategoryTVC+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation

extension CategoryTVC : CatCirclesFetcherDelegate {
    
    
    
    //MARK: - Delegate Methods
    
    func launchCircleUpdated(circleID: String, launchCircle: LaunchCircle) {
        
        self.deleteLaunchCircle(circleID: circleID)
        self.insertLaunchCircle(launchCircle: launchCircle)
        
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func launchCircleRemoved(circleID: String) {
        
        self.deleteLaunchCircle(circleID: circleID)
        
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
        
    }
    
    
    
    
    //MARK: - Internal Insertion Methods
    
    func insertLaunchCircle(launchCircle : LaunchCircle) {
        var section = 0
        if !launchCircle.amMember() {
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
    
    
    
    
}