//
//  LaunchTVC+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit


extension LaunchTVC : AllCirclesFetcherDelegate {
    
    //MARK: - Delegate Methods
    
    
    func allCirclesFetched(launchCircleArray: [LaunchCircle]) {
        
        self.tableView.backgroundView = nil
        if refreshControl?.isRefreshing == true {
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
        
        self.circleArray = launchCircleArray
        tableView.reloadData()
        
        //push data up to categoryVC if on top
        for vc in self.navigationController?.viewControllers ?? [] {
            if let categoryVC = vc as? CategoryTVC {
                categoryVC.allCirclesFetched(launchCircleArray: launchCircleArray)
            }
        }
        
    }


    
    
}
