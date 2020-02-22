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
    
    var category : String!
    var circleArray : [LaunchCircle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "categoryCell")
    }
    
    deinit {
        print("sx categoryTVC")
    }
    
    func shutDown() {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.getMyCircles().count
        }
        else if section == 1 {
            return self.getRestCircles().count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.accessoryType = .detailButton
        cell.selectionStyle = .none
        
        var followString = ""
        var subString = ""
        if section == 0 {
            let c = self.getMyCircles()[row]
            cell.imageView?.image = self.imageWith(string: c.circleEmoji)
            cell.textLabel?.text = c.circleName
            followString = "· J✓"
            subString = "\(c.memberArray.count) members \(followString)"
        }
        if section == 1 {
            let c = self.getRestCircles()[row]
            cell.imageView?.image = self.imageWith(string: c.circleEmoji)
            cell.textLabel?.text = c.circleName
            followString = "· Join"
            subString = "\(c.memberArray.count) members \(followString)"
        }
        
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
            if self.getMyCircles().isEmpty {
                return nil
            } else {
                return "My Group Chats"
            }
        } else {
            if self.getRestCircles().isEmpty {
                return nil
            } else {
                return "All"
            }
        }
    }
    
    
}


