//
//  LaunchTVC+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation



extension LaunchTVC : CatCirclesFetcherDelegate, CategoriesFetcherDelegate {
    
    //MARK: - Delegate Methods 1
    
    func categoriesFetched(categoryArray: [CircleCategory]) {
        self.categoryArray = categoryArray
        
        //FIX: better sort categories
        
        
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    
    
    //MARK: - Delegate Methods 2
    
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
        
        self.myCircleArray.append(launchCircle)
        
        self.sortCircleArray()
    }
    
    func deleteLaunchCircle(circleID : String) {
        
        self.myCircleArray.removeAll(where: {$0.circleID == circleID})
    }
    

    
    
}
