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
    
    func sortArray(array : [LaunchCircle]) -> [LaunchCircle] {
        
        guard let option = UserDefaults.standard.value(forKey: defaultsKeys.launchSortOption) as? Int else {
            return sortMyFav(array: array)
        }
        
        if option == LaunchSortOption.aToZ.rawValue {
            return self.sortAToZ(array: array)
        }
        else if option == LaunchSortOption.myFav.rawValue {
            return self.sortMyFav(array: array)
        }
        else if option == LaunchSortOption.campusFav.rawValue {
            return self.sortCampusFav(array: array)
        }
        else {
            return self.sortAToZ(array: array)
        }
        
        
    }
    
    
    //MARK: - Sort Button Tapped
    
    @objc func sortButtonTapped() {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "A to Z", style: .default, handler: { (action) in
            UserDefaults.standard.set(LaunchSortOption.aToZ.rawValue, forKey: defaultsKeys.launchSortOption)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "My Favorites", style: .default, handler: { (action) in
            UserDefaults.standard.set(LaunchSortOption.myFav.rawValue, forKey: defaultsKeys.launchSortOption)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Campus Favorites", style: .default, handler: { (action) in
            UserDefaults.standard.set(LaunchSortOption.campusFav.rawValue, forKey: defaultsKeys.launchSortOption)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            //
        }))
        self.present(alert, animated: true)
        
    }

    
    
    //MARK: - Different Sorts
    
    func sortAToZ(array : [LaunchCircle]) -> [LaunchCircle] {
        
        let ary = array.sorted { (c1, c2) -> Bool in
            return c1.circleName.lowercased() < c2.circleName.lowercased()
        }
        return ary
    }
    
    func sortMyFav(array : [LaunchCircle]) -> [LaunchCircle] {
        
        let dict = self.myFavLaunchCircles
        
        let ary = array.sorted { (c1, c2) -> Bool in
            if (dict[c1.circleID] ?? 0) != (dict[c2.circleID] ?? 0) {
                return (dict[c1.circleID] ?? 0) > (dict[c2.circleID] ?? 0)
            }
            else {
                return c1.circleName.lowercased() < c2.circleName.lowercased()
            }
        }
        
        return ary
        
    }
    
    func sortCampusFav(array : [LaunchCircle]) -> [LaunchCircle] {
        
        let ary = array.sorted { (c1, c2) -> Bool in
            return c1.memberArray.count > c2.memberArray.count
        }
        return ary
    }
    
    
    
}
