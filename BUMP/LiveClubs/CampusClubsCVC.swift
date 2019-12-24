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


class CampusClubsCVC: UICollectionViewController {
    
    final let numColumns : Int = 2
    final let gridSpacing : CGFloat = 30.0
    
    var clubsFetcher : ClubsFetcher?
    
//    var clubInfoDict : [String : ClubInfo] = [:]
    var clubInfoArray : [ClubInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        self.setupClubsFetcher()
        
        let x = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.setRightBarButton(x, animated: true)
        
    }
    
    func shutDown() {
        
        self.clubsFetcher?.shutDown()
        self.clubsFetcher?.delegate = nil
        self.clubInfoArray = []
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
    
    
    func setupClubsFetcher() {
        
        self.clubsFetcher = ClubsFetcher()
        self.clubsFetcher?.delegate = self
        self.clubsFetcher?.monitorCampusClubs()
        
    }
    
    func setupCollectionView() {
        self.collectionView!.register(ClubCell.self, forCellWithReuseIdentifier: "clubCell")
        
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
        return clubInfoArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clubCell", for: indexPath) as! ClubCell
        
        let cInfo = clubInfoArray[indexPath.item]
        

        for s in cell.contentView.subviews {
            s.removeFromSuperview()
        }
        
        cell.layoutCell()
        
        cell.clubTitleLabel.text = cInfo.circleID
        cell.numMembersLabel.text = "\(cInfo.followerIDArray.count) Members"
        
        if cInfo.userHereArray.count == 0 {
            cell.setupXAloneView()
        } else {
            cell.usersHereLabel.text = "\(cInfo.userHereArray.count) HERE"
            cell.setupXView()
        }

        if cInfo.followerIDArray.contains(Auth.auth().currentUser?.uid ?? "x_x") {
            cell.followButton.setTitle("F✓", for: .normal)
            cell.followButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .semibold)
        } else {
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .semibold)
            cell.followButton.setTitleColor(Constant.oBlue, for: .normal)
        }
        
        
    
        return cell
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cInfo = clubInfoArray[indexPath.item]
        let circleID = cInfo.circleID
        
        
        if LoginManager.shared.isLoggedIn() {
            let c = CircleManager.shared
            c.launchCircle(circleID: circleID, circleName: circleID)
            //FIX : circleID & circleName is different
        }
    
        
        
    }

}


extension CampusClubsCVC : UICollectionViewDelegateFlowLayout {
    
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



extension CampusClubsCVC : ClubsFetcherDelegate {
    
    func clubUpdated(clubInfo: ClubInfo) {
        
        if let index = self.clubInfoArray.firstIndex(where: { (cInfo) -> Bool in
            return cInfo.circleID == clubInfo.circleID
        }) {
            self.clubInfoArray[index] = clubInfo
        }
        else {
            self.clubInfoArray.append(clubInfo)
            self.sortClubInfoArray()
        }
        
        self.collectionView.reloadData()
    }
    
    func clubRemoved(clubID : String) {
        self.clubInfoArray.removeAll(where: {$0.circleID == clubID})
        self.collectionView.reloadData()
    }
    
    

    
    func sortClubInfoArray() {
        self.clubInfoArray.sort { (c1, c2) -> Bool in
            if c1.userHereArray.count == c2.userHereArray.count {
                return c1.circleID < c2.circleID
            }
            else {
                return c1.userHereArray.count > c2.userHereArray.count
            }
        }
    }
    
}
