//
//  CategoryTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

class CategoryTVC: UITableViewController {
    
    var categoryID : String!
    
    var launchFetcher : CatCirclesFetcher?
    
    var circleArray : [[LaunchCircle]] = [[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLaunchFetcher()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "launchCell")
        
//        if categoryID == "Classes" {
//        for i in 0...460 {
//            self.circleArray[1].append(LaunchCircle(circleID: "circleID", circleName: "Circle # \(i)", circleEmoji: "😎", circleDescription: "circleDescr", memberArray: []))
//        }
//        }
    }
    
    func shutDown() {
        self.launchFetcher?.shutDown()
        self.circleArray = [[], []]
        
        NotificationCenter.default.removeObserver(self)
        
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.shutDown()
        //        self.refreshLaunchFetcher()
    }
    
    
    
    //MARK: - Setup
    
    func setupLaunchFetcher() {
        
        self.launchFetcher = CatCirclesFetcher(categoryID: self.categoryID)
        self.launchFetcher?.delegate = self
        self.launchFetcher?.monitorCategoryCircles()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return circleArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circleArray[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath)
        cell.accessoryType = .detailButton
        cell.selectionStyle = .none
        
        let c = circleArray[indexPath.section][indexPath.row]
        
        cell.imageView?.image = self.imageWith(string: c.circleEmoji)
        cell.textLabel?.text = c.circleName
        
        
        var followString = "· Join"
        if c.amMember() {
            followString = "· J✓"
        }
        
        let subString = "\(c.memberArray.count) members \(followString)"
        let fullRange = (subString as NSString).range(of: subString)
        let followRange = (subString as NSString).range(of: followString)
        let attributedString = NSMutableAttributedString(string: subString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Constant.oBlue, range: followRange)
        
        cell.detailTextLabel?.attributedText = attributedString
        
        let tapGesture = IndexTapGestureRecognizer(target: self, action: #selector(joinButtonTapped))
        tapGesture.indexPath = indexPath
        cell.detailTextLabel?.isUserInteractionEnabled = true
        cell.detailTextLabel?.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    
    
    func imageWith(string: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 150, height: 200)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 100)
        //        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = string
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if self.circleArray[0].isEmpty {
                return nil
            } else {
                return "My Group Chats"
            }
        } else {
            if self.circleArray[1].isEmpty {
                return nil
            } else {
                return "All"
            }
        }
    }
    
    
}


