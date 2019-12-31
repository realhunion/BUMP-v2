//
//  ViewController.swift
//  BUMP
//
//  Created by Hunain Ali on 10/20/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import Firebase
import SwiftEntryKit

enum Tabs: Int {
    case followingClubs = 0
    case campusClubs = 1
    case categories = 2
}

class HomeTabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        self.delegate = self
        
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
    }
    
    func shutDown() {
//        
//        liveFriendsVC.shutDown()
//        notificationVC.shutDown()
//        circleManager.shutDown()
        
    }
    
    
    
    
    var feedVC = FeedTVC()
    var campusClubsVC = LaunchCVC(collectionViewLayout: UICollectionViewFlowLayout())
    var categoriesVC = SettingsCVC(collectionViewLayout: UICollectionViewFlowLayout())
    
    func setupTabBar() {
        
        feedVC.view.backgroundColor = .white
        campusClubsVC.view.backgroundColor = .white
        categoriesVC.view.backgroundColor = .white
        
        feedVC.title = "Campus"
        campusClubsVC.title = "Launch"
        categoriesVC.title = "Settings"
        
        
        let feedNC = UINavigationController(rootViewController: feedVC)
        let campusClubsNC = UINavigationController(rootViewController: campusClubsVC)
        let categoriesNC = UINavigationController(rootViewController: categoriesVC)
        
        feedVC.navigationController?.navigationBar.prefersLargeTitles = true
        feedVC.navigationController?.navigationBar.layoutMargins.left = 30
        campusClubsVC.navigationController?.navigationBar.prefersLargeTitles = true
        campusClubsVC.navigationController?.navigationBar.layoutMargins.left = 36
        categoriesVC.navigationController?.navigationBar.prefersLargeTitles = true
        
        feedNC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        campusClubsNC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        categoriesNC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]

        
        let feedImage =  UIImage(named: "campusIcon")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        let campusImage = UIImage(named: "launchIcon")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        let categoriesImage = UIImage(named: "categoriesIcon")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        
        let feedItem = UITabBarItem(title: "Campus", image: feedImage, selectedImage: nil)
        let campusClubsItem = UITabBarItem(title: "Launch", image: campusImage, selectedImage: nil)
        let categoriesItem = UITabBarItem(title: "Settings", image: categoriesImage, selectedImage: nil)
        
        
        feedItem.tag = 0
        campusClubsItem.tag = 1
        categoriesItem.tag = 2
        
        feedVC.tabBarItem = feedItem
        campusClubsVC.tabBarItem = campusClubsItem
        categoriesVC.tabBarItem = categoriesItem
        
        let tabBarControllers = [feedNC, campusClubsNC, categoriesNC]
        self.viewControllers = tabBarControllers
        self.selectedIndex = currentIndex
        
        
        
    }
    
    
    
    
    var currentIndex : Int = Tabs.followingClubs.rawValue
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        currentIndex = selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if selectedIndex == Tabs.followingClubs.rawValue {
            if !LoginManager.shared.isLoggedIn() {
                self.selectedIndex = currentIndex
            }
            else {
//                self.feedVC.sortClubInfoArray()
//                self.feedVC.collectionView.reloadData()
//                self.feedVC.collectionView.scrollToTop(true)
            }
        }
        
        
        
        if selectedIndex == Tabs.campusClubs.rawValue {
            self.campusClubsVC.sortClubInfoArray()
            self.campusClubsVC.collectionView.reloadData()
            self.campusClubsVC.collectionView.scrollToTop(true)
            
        }
        
        
        if selectedIndex == Tabs.categories.rawValue {
            self.categoriesVC.collectionView.scrollToTop(true)
            
        }
        
    }
    
    
    

}
