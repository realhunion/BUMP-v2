//
//  CircleInfoTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 1/15/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit
import Firebase
import SwiftEntryKit

class CircleInfoTVC: UITableViewController {
    
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var storageRef = Storage.storage()
    
    var circleID : String!
    var circleName : String!
    var circleDescription : String!
    
    var circleMembersFetcher : CircleMembersFetcher?
    var circleMembers : [UserProfile] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.circleMembersFetcher = CircleMembersFetcher(circleID: self.circleID)
        self.circleMembersFetcher?.delegate = self
        self.circleMembersFetcher?.fetchCircleMembers()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "circleInfoCell")
        self.setupDoneButton()
    }
    
    func setupDoneButton() {
        let btn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.setRightBarButton(btn, animated: true)
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
        

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.circleMembers.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Description"
        } else {
            return "Members"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleInfoCell", for: indexPath)
        cell.selectionStyle = .none
        if indexPath.section == 1 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.imageView?.image = nil
                cell.textLabel?.text = self.circleDescription
                cell.textLabel?.numberOfLines = 99
            }
            
        }
        else {
            let user = self.circleMembers[indexPath.row]
            cell.textLabel?.text = user.userName
            cell.detailTextLabel?.text = user.userHandle
        }
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section == 1 else { return }
        
        let user = self.circleMembers[indexPath.row]
        
        let vc = UserProfileView(userID: user.userID, actionButtonEnabled: false)
        let atr = Constant.bottomPopUpAttributes
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: vc, using: atr)
        }
    }
    

}


extension CircleInfoTVC : CircleMembersFetcherDelegate {
    
    func circleMembersFetched(circleMembers: [UserProfile]) {
        self.circleMembers = circleMembers
        self.tableView.reloadData()
//        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    
}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
