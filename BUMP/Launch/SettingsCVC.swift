//
//  CategoryClubsCVC.swift
//  BUMP
//
//  Created by Hunain Ali on 11/12/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftEntryKit

class SettingsCVC : UICollectionViewController {
    
    var db = Firestore.firestore()
    
    final let numColumns : Int = 2
    final let gridSpacing : CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(ClubCell.self, forCellWithReuseIdentifier: "clubCell")
        
        self.setupCollectionView()
        
        let x = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        self.navigationItem.setRightBarButton(x, animated: true)
        
    }
    
    @objc func settingsTapped() {
        
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
        
        self.collectionView.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.0)
        self.collectionView.alwaysBounceVertical = true
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clubCell", for: indexPath) as! ClubCell
        
        if indexPath.row == 0 {
            cell.circleTitleLabel.text = "Silence for 1h"
        }
        else if indexPath.row == 1 {
            cell.circleTitleLabel.text = "Silence for 3h"
        }
        else if indexPath.row == 2 {
            cell.circleTitleLabel.text = "Silence for 12h"
        }
        else {
            cell.circleTitleLabel.text = "UnSilence"
        }
        
        
        cell.followButton.isHidden = true
        
        return cell
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
   
        if indexPath.row == 0 {
            let t = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            var data : [String : Any] = [:]
            data["silenceUntil"] = t
            db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
                self.presentOkView()
            }
        }
        else if indexPath.row == 1 {
            let t = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
            var data : [String : Any] = [:]
            data["silenceUntil"] = t
            db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
                self.presentOkView()
            }
        }
        else if indexPath.row == 2 {
            let t = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
            var data : [String : Any] = [:]
            data["silenceUntil"] = t
            db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
                self.presentOkView()
            }
        }
        else {
            var data : [String : Any] = [:]
            data["silenceUntil"] = FieldValue.delete()
            db.collection("User-Base").document(myUID).updateData(data) { (err) in
                self.presentOkView()
            }
        }
        
        
    }
    
    func presentOkView() {
        let alert = UIAlertController(title: "Done", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
                
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension SettingsCVC : UICollectionViewDelegateFlowLayout {
    
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
        return UIEdgeInsets(top: self.gridSpacing, left: self.gridSpacing, bottom: self.gridSpacing, right: self.gridSpacing)
    }
    
    
}
    

