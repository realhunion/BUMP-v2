//
//  ClubsCVC.swift
//  BUMP
//
//  Created by Hunain Ali on 10/24/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import Firebase
import SPStorkController
import SwiftEntryKit
import QuickLayout


class LaunchCVC: UICollectionViewController {
    
    var db = Firestore.firestore()
    
    final let numColumns : Int = 2
    final let gridSpacing : CGFloat = 30.0
    
    var launchFetcher : LaunchFetcher?
    
    var circleArray : [LaunchCircle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        self.setupLaunchFetcher()
        
        let x = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.setRightBarButton(x, animated: true)
        
    }
    
    func shutDown() {
        
        self.launchFetcher?.shutDown()
        self.launchFetcher?.delegate = nil
        self.circleArray = []
        self.collectionView.reloadData()
        
    }
    
    @objc func addButtonTapped() {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        let c = SendSuggestionView()
        
        var atr = Constant.centerPopUpAttributes
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        DispatchQueue.main.async {
            
            SwiftEntryKit.display(entry: c, using: atr)
        }
        
    }
    
    
    func setupLaunchFetcher() {
        
        self.launchFetcher = LaunchFetcher()
        self.launchFetcher?.delegate = self
        self.launchFetcher?.monitorLaunchCircles()
        
    }
    
    func setupCollectionView() {
        self.collectionView!.register(ClubCell.self, forCellWithReuseIdentifier: "clubCell")
        
        self.collectionView.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.0)
        self.collectionView.alwaysBounceVertical = true
    }

    
    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return circleArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clubCell", for: indexPath) as! ClubCell
        
        guard let myUID = Auth.auth().currentUser?.uid else { return cell }
        
        
        let cInfo = circleArray[indexPath.item]
        
        
        cell.circleTitleLabel.text = cInfo.circleName
        cell.numMembersLabel.text = "\(cInfo.followerIDArray.count) Members · \(cInfo.circleEmoji)"
//        cell.numMembersLabel.text = "\(cInfo.circleEmoji) · \(cInfo.followerIDArray.count) Members"

        cell.followButton.isSelected = cInfo.followerIDArray.contains(myUID)
        cell.followButtonAction = { [unowned self] in
            if cell.followButton.isSelected == false {
                self.followCircle(circleID: cInfo.circleID)
            } else {
                self.unFollowCircle(circleID: cInfo.circleID)
            }
        }
    
        return cell
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cInfo = circleArray[indexPath.item]
        let circleID = cInfo.circleID
        let circleName = cInfo.circleName
        let circleEmoji = cInfo.circleEmoji
        
        if LoginManager.shared.isLoggedIn() {
            let c = CircleManager.shared
            c.launchCircle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        }
    
        
        
    }

}


extension LaunchCVC : UICollectionViewDelegateFlowLayout {
    
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
