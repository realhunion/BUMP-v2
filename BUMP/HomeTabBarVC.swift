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
    case feed = 0
    case launch = 1
    case hub = 2
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
    var hubVC = HubCVC(collectionViewLayout: UICollectionViewFlowLayout())
    
    func setupTabBar() {
        
        feedVC.view.backgroundColor = .white
        campusClubsVC.view.backgroundColor = .white
        hubVC.view.backgroundColor = .white
        
        feedVC.title = "Campus"
        campusClubsVC.title = "Launch"
        hubVC.title = "Bump"
        
        
        let feedNC = UINavigationController(rootViewController: feedVC)
        let campusClubsNC = UINavigationController(rootViewController: campusClubsVC)
        let hubNC = UINavigationController(rootViewController: hubVC)
        
        feedVC.navigationController?.navigationBar.prefersLargeTitles = true
        feedVC.navigationController?.navigationBar.layoutMargins.left = 30
        campusClubsVC.navigationController?.navigationBar.prefersLargeTitles = true
        campusClubsVC.navigationController?.navigationBar.layoutMargins.left = 36
        hubVC.navigationController?.navigationBar.prefersLargeTitles = true
        hubVC.navigationController?.navigationBar.layoutMargins.left = 42
        
        feedNC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        campusClubsNC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        hubNC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]

        
        let feedImage =  UIImage(named: "campusIcon")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        let campusImage = UIImage(named: "launchIcon")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        let categoriesImage = UIImage(named: "hubIcon")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        
        let feedItem = UITabBarItem(title: "Campus", image: feedImage, selectedImage: nil)
        let campusClubsItem = UITabBarItem(title: "Launch", image: campusImage, selectedImage: nil)
        let hubItem = UITabBarItem(title: "Bump", image: categoriesImage, selectedImage: nil)
        
        
        feedItem.tag = 0
        campusClubsItem.tag = 1
        hubItem.tag = 2
        
        feedVC.tabBarItem = feedItem
        campusClubsVC.tabBarItem = campusClubsItem
        hubVC.tabBarItem = hubItem
        
        let tabBarControllers = [feedNC, campusClubsNC, hubNC]
        self.viewControllers = tabBarControllers
        self.selectedIndex = currentIndex
        
        
        
    }
    
    
    
    
    var currentIndex : Int = Tabs.feed.rawValue
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        currentIndex = selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if selectedIndex == Tabs.feed.rawValue {
            if !LoginManager.shared.isLoggedIn() {
                self.selectedIndex = currentIndex
            }
//            else {
//                self.feedVC.sortClubInfoArray()
//                self.feedVC.collectionView.reloadData()
//                self.feedVC.collectionView.scrollToTop(true)
//            }
        }
        
        
        
//        if selectedIndex == Tabs.launch.rawValue {
//            self.campusClubsVC.sortClubInfoArray()
//            self.campusClubsVC.collectionView.reloadData()
//            self.campusClubsVC.collectionView.scrollToTop(true)
//
//        }
//
//
//        if selectedIndex == Tabs.hub.rawValue {
//            self.categoriesVC.collectionView.scrollToTop(true)
//
//        }
        
    }
    
    
    

}
