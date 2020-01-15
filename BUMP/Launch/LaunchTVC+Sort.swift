//
//  LaunchTVC+Sort.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit


struct LaunchSortOption: OptionSet {
    let rawValue: Int
    
    static let aToZ = LaunchSortOption(rawValue: 1 << 0)
    static let myFav = LaunchSortOption(rawValue: 1 << 1)
    static let campusFav = LaunchSortOption(rawValue: 1 << 2)
}

extension LaunchTVC {
    
    
    func sortCircleArray() {
        
        guard let option = UserDefaults.standard.value(forKey: defaultsKeys.launchSortOption) as? LaunchSortOption else {
            self.sortAToZ()
            return
        }
        
        if option == .aToZ {
            self.sortAToZ()
        }
        else if option == .myFav {
            self.sortMyFav()
        }
        else if option == .campusFav {
            self.sortCampusFav()
        }
        else {
            self.sortAToZ()
        }
        
        
    }
    
    
    //MARK: - Sort Button Tapped
    
    func setupSortButton() {
        let btn = UIBarButtonItem(title: "Aa↓", style: .plain, target: self, action: #selector(sortButtonTapped))
        self.navigationItem.setRightBarButton(btn, animated: true)
    }
    
    @objc func sortButtonTapped() {
        
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "A to Z", style: .default, handler: { (action) in
            UserDefaults.standard.set(LaunchSortOption.aToZ.rawValue, forKey: defaultsKeys.launchSortOption)
            self.sortAToZ()
            self.tableView.reloadData()
        }))
//        alert.addAction(UIAlertAction(title: "My Favorites", style: .default, handler: { (action) in
//            //
//        }))
        alert.addAction(UIAlertAction(title: "Campus Favorites", style: .default, handler: { (action) in
            UserDefaults.standard.set(LaunchSortOption.campusFav.rawValue, forKey: defaultsKeys.launchSortOption)
            self.sortCampusFav()
            self.tableView.reloadData()
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
        //
    }
    
    func sortCampusFav() {
        
        for section in 0..<self.circleArray.count {
            
            self.circleArray[section].sort { (c1, c2) -> Bool in
                return c1.followerIDArray.count > c2.followerIDArray.count
            }
        }
    }
    
    
    
}
