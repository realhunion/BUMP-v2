//
//  SubLaunchTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 3/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit

class SubLaunchTVC : LaunchTVC {
    
    override func viewDidLoad() {
        //
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "launchCell")
        self.tableView.register(AccessoryTableViewCell.classForCoder(), forCellReuseIdentifier: "categoryCell")
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            guard LoginManager.shared.isLoggedIn() else { return }
            
            let circle = self.getMyCircles()[indexPath.row]
            
            CircleManager.shared.launchCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
        }
        
        if indexPath.section == 1 {
            
            let category = self.getCategoryArray()[indexPath.row]
            let categoryCircleArray = self.getCategoryCircleArray(category: category)
            
            let vc = CategoryTVC(style: .grouped)
            vc.title = category.stringByRemovingEmoji()
            vc.circleArray = categoryCircleArray
            vc.category = category
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            
        }
    }
    
    
    
    
    
    //MARK: - Internal Methods
    
    
    override func getMyCircles() -> [LaunchCircle] {
        var array = self.circleArray.filter({$0.amMember()})
        array = self.sortArray(array: array)
        return array
    }
    
    //
    
    override func getCategoryArray() -> [String] {
        var categoryArray : [String] = []
        for circle in self.circleArray {
            if !categoryArray.contains(where: {$0 == circle.category2}) {
                categoryArray.append(circle.category2 ?? "")
            }
        }
        categoryArray.sort { (c1, c2) -> Bool in
            return c1 < c2
        }
        return categoryArray
    }
    
    override func getCategoryCircleArray(category : String) -> [LaunchCircle] {
        let filteredCategoryArray = self.circleArray.filter({$0.category2 == category})
        return filteredCategoryArray
    }
    
}
