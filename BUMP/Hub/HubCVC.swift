//
//  HubCVC.swift
//  BUMP
//
//  Created by Hunain Ali on 11/12/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftEntryKit


struct HubItem {
    var title : String
}

class HubCVC : UICollectionViewController {
    
    var db = Firestore.firestore()
    
    final let numColumns : Int = 2
    final let gridSpacing : CGFloat = 36.0
    
    var hubItemArray = [HubItem(title: "The Purpose of Bump"),
                        HubItem(title: "How To Use"),
                        HubItem(title: "My Profile"),
                        HubItem(title: "My Circles"),
                        HubItem(title: "Silence Mode"),
                        HubItem(title: "Contact Us")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(HubCell.self, forCellWithReuseIdentifier: "hubCell")
        
        self.setupCollectionView()
        
        let x = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        self.navigationItem.setRightBarButton(x, animated: true)
        
    }
    
    @objc func settingsTapped() {
        
        //FIX:
        guard LoginManager.shared.isLoggedIn() else { return }
        
        let settingsVC = SettingsTVC(style: .plain)
        let navVC = UINavigationController(rootViewController: settingsVC)
        navVC.view.layer.cornerRadius = 18.0
        navVC.view.layer.masksToBounds = true
        
        let attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
        
        DispatchQueue.main.async {
            
            SwiftEntryKit.display(entry: navVC, using: attributes)
        }
        
    }
    func setupCollectionView() {
        
        self.collectionView.backgroundColor = Constant.oGrayLight
        self.collectionView.alwaysBounceVertical = true
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.hubItemArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hubCell", for: indexPath) as! HubCell
        
        let hubItem = self.hubItemArray[indexPath.row]
        
        cell.titleLabel.text = hubItem.title
        
        return cell
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let hubItem = self.hubItemArray[indexPath.item]
   
        if indexPath.row == 0 {
            UserDefaultsManager.shared.clearAllData()
        }
        else if indexPath.row == 1 {
            self.presentIntroInfo()
        }
        else if indexPath.row == 2 {
            self.presentMyProfile()
        }
        else if indexPath.row == 3 {
            self.presentMyCircles()
        }
        else if indexPath.row == 4 {
            self.presentSilenceMode()
        }
        else if indexPath.row == 5 {
            self.presentHelpline()
        }
        
        
    }
    
}


extension HubCVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numEmptyColumns = CGFloat(self.numColumns + 1)
        let width = (self.collectionView.bounds.width - (self.gridSpacing * numEmptyColumns) ) / CGFloat(self.numColumns)
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.gridSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.gridSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.gridSpacing/2, left: self.gridSpacing, bottom: self.gridSpacing/2, right: self.gridSpacing)
    }
    
    
}
    

