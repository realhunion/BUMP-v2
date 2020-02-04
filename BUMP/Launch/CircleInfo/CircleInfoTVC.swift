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

enum CircleInfoSection : String {
    case options = "Member Options"
    case description = "Description"
    case members = "Members"
}

class CircleInfoTVC: UITableViewController {
    
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var db = Firestore.firestore()
    var storageRef = Storage.storage()
    
    var circleID : String!
    var circleName : String!
    var circleEmoji : String!
    var circleDescription : String!
    var circleMemberArray : [LaunchMember] = []
    
    var circleMembersFetcher : CircleMembersFetcher?
    var memberProfileArray : [UserProfile] = []
    
    var sections : [CircleInfoSection] = [.description]
    
    
    
    lazy var notifsOnSwitcher : UISwitch = {
        let switchView = UISwitch(frame: .zero)
        switchView.isEnabled = true
        switchView.addTarget(self, action: #selector(self.notificationsToggled(_:)), for: .valueChanged)
        return switchView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCircleMembersFetcher()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "circleInfoCell")
        self.setupDoneButton()
        
        self.setupMemberOptionsCell()
    }
    
    func setupCircleMembersFetcher() {
        
        self.circleMembersFetcher = CircleMembersFetcher(circleID: self.circleID)
        self.circleMembersFetcher?.delegate = self
        //        self.circleMembersFetcher?.fetchAllCircleMembers()
        self.circleMembersFetcher?.fetchCircleMembers(userIDArray: self.circleMemberArray.map({$0.userID}))
    }
    
    func setupMemberOptionsCell() {
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        if let myMember = circleMemberArray.first(where: {$0.userID == myUID}) {
            self.sections.insert(.options, at: 0)
            self.notifsOnSwitcher.isOn = myMember.notifsOn
        }
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
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sections[section] == .options {
            return 1
        }
        else if self.sections[section] == .description {
            return 1
        }
        else if self.sections[section] == .members {
            return self.memberProfileArray.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].rawValue
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleInfoCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        if self.sections[indexPath.section] == .options {
            cell.textLabel?.text = "Launch Notifications"
            cell.detailTextLabel?.text = "Know when someone wants to connect."
            cell.accessoryView = self.notifsOnSwitcher
        }
        else if self.sections[indexPath.section] == .description {
            cell.accessoryType = .none
            cell.accessoryView = nil
            cell.textLabel?.numberOfLines = 99
            cell.textLabel?.text = self.circleDescription
            cell.detailTextLabel?.text = nil
            
        }
        else if self.sections[indexPath.section] == .members {
            let user = self.memberProfileArray[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = nil
            cell.textLabel?.text = user.userName
            cell.detailTextLabel?.text = user.userHandle
            
        }
        else { }
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard self.sections[indexPath.section] == .members else { return }
        
        let user = self.memberProfileArray[indexPath.row]
        
        let vc = UserProfileView(userID: user.userID, actionButtonEnabled: false)
        let atr = Constant.bottomPopUpAttributes
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: vc, using: atr)
        }
    }
    

}
