//
//  LaunchCVC+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 12/30/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation


extension LaunchCVC : LaunchFetcherDelegate {
    
    
    func launchCircleUpdated(circleID : String, launchCircle: LaunchCircle) {
        
        if let index = self.circleArray.firstIndex(where: { (cInfo) -> Bool in
            return cInfo.circleID == circleID
        }) {
            self.circleArray[index] = launchCircle
        }
        else {
            self.circleArray.append(launchCircle)
            self.sortClubInfoArray()
        }
        
        self.collectionView.reloadData()
    }
    
    
    func launchCircleRemoved(circleID: String) {
        self.circleArray.removeAll(where: {$0.circleID == circleID})
        self.collectionView.reloadData()
    }
    
    
    
    
    func sortClubInfoArray() {
        self.circleArray.sort { (c1, c2) -> Bool in
            //            if c1.userHereArray.count == c2.userHereArray.count {
            //                return c1.circleID < c2.circleID
            //            }
            //            else {
            //                return c1.userHereArray.count > c2.userHereArray.count
            //            }
            
            //FIX: Sorting example
            
            return c1.circleID < c2.circleID
        }
    }
    
}
