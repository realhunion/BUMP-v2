//
//  LaunchTVC+Sort.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit
import Firebase


struct LaunchSortOption: OptionSet {
    let rawValue: Int
    
    static let aToZ = LaunchSortOption(rawValue: 0)
    static let myFav = LaunchSortOption(rawValue: 1)
    static let campusFav = LaunchSortOption(rawValue: 2)
}

extension LaunchTVC {
    
    
    func sortCircleArray() {
        
        guard let option = UserDefaults.standard.value(forKey: defaultsKeys.launchSortOption) as? Int else {
            self.sortAToZ()
            return
        }
        
        if option == LaunchSortOption.aToZ.rawValue {
            self.sortAToZ()
        }
        else if option == LaunchSortOption.myFav.rawValue {
            self.sortMyFav()
        }
        else if option == LaunchSortOption.campusFav.rawValue {
            self.sortCampusFav()
        }
        else {
            self.sortAToZ()
        }
        
        
    }
    
    
    //MARK: - Sort Button Tapped
    
    @objc func sortButtonTapped() {
        
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "A to Z", style: .default, handler: { (action) in
            UserDefaults.standard.set(LaunchSortOption.aToZ.rawValue, forKey: defaultsKeys.launchSortOption)
            
            DispatchQueue.main.async {
                self.sortCircleArray()
                self.tableView.reloadData()
            }
        }))
        if let myUID = Auth.auth().currentUser?.uid {
            alert.addAction(UIAlertAction(title: "My Favorites", style: .default, handler: { (action) in
                UserDefaults.standard.set(LaunchSortOption.myFav.rawValue, forKey: defaultsKeys.launchSortOption)
                
                DispatchQueue.main.async {
                    self.sortCircleArray()
                    self.tableView.reloadData()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "Campus Favorites", style: .default, handler: { (action) in
            UserDefaults.standard.set(LaunchSortOption.campusFav.rawValue, forKey: defaultsKeys.launchSortOption)
            
            DispatchQueue.main.async {
                self.sortCircleArray()
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            //
        }))
        self.present(alert, animated: true)
        
    }

    
    
    //MARK: - Different Sorts
    
    func sortAToZ() {
        
        for section in 0..<self.circleArray.count {
            
            self.circleArray[section].sort { (c1, c2) -> Bool in
                return c1.circleName.lowercased() < c2.circleName.lowercased()
            }
        }
    }
    
    func sortMyFav() {
        
        let dict = UserDefaultsManager.shared.getMyFavLaunchCircles()
        
        for section in 0..<self.circleArray.count {
            
            self.circleArray[section].sort { (c1, c2) -> Bool in
                
                if (dict[c1.circleID] ?? 0) != (dict[c2.circleID] ?? 0) {
                    return (dict[c1.circleID] ?? 0) > (dict[c2.circleID] ?? 0)
                }
                else {
                    return c1.circleName.lowercased() < c2.circleName.lowercased()
                }
                
            }
        }
    }
    
    func sortCampusFav() {
        
        for section in 0..<self.circleArray.count {
            
            self.circleArray[section].sort { (c1, c2) -> Bool in
                return c1.memberArray.count > c2.memberArray.count
            }
        }
    }
    
    
    
}
