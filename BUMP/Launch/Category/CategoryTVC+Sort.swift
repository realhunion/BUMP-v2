//
//  CategoryTVC+Sort.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase


extension CategoryTVC {
    
    
    func sortCircleArray() {
        
        self.sortAToZ()
        
        
    }
    
    
    
    //MARK: - Different Sorts
    
    
    func sortAToZ() {
        
        for section in 0..<self.circleArray.count {
            
            self.circleArray[section].sort { (c1, c2) -> Bool in
                return c1.circleName.lowercased() < c2.circleName.lowercased()
            }
        }
    }
    
    
    
}
