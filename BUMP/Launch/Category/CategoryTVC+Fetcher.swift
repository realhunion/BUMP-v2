//
//  CategoryTVC+Fetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation

extension CategoryTVC : AllCirclesFetcherDelegate {
    
    
    //MARK: - Delegate

    func allCirclesFetched(launchCircleArray: [LaunchCircle]) {
        
        
        self.circleArray = launchCircleArray.filter({$0.category == self.category})
        tableView.reloadData()
    }
    
    
    
    //MARK: - Internal Insertion Methods
    
    func getMyCircles() -> [LaunchCircle] {
        var array = self.circleArray.filter({$0.amMember()})
        array = self.sortArray(array: array)
        return array
    }
    
    func getRestCircles() -> [LaunchCircle] {
        var array = self.circleArray.filter({!$0.amMember()})
        array = self.sortArray(array: array)
        return array
    }
    
    
    //mARK: - Sorting
    
    func sortArray(array : [LaunchCircle]) -> [LaunchCircle] {
        let ary = array.sorted { (c1, c2) -> Bool in
            return c1.circleName < c2.circleName
        }
        return ary
    }
    
    
}
