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
    case options = "Options"
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
    
    var sections : [CircleInfoSection] = [.options, .description, .members]
    
    
    
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
    }
    
    func setupCircleMembersFetcher() {
        
        self.circleMembersFetcher?.shutDown()
        
        self.circleMembersFetcher = CircleMembersFetcher(circleID: self.circleID)
        self.circleMembersFetcher?.delegate = self
//                self.circleMembersFetcher?.fetchAllCircleMembers()
        self.circleMembersFetcher?.fetchCircleMembers(userIDArray: self.circleMemberArray.map({$0.userID}))
    }
    
    func refreshCircleMembersFetcher() {
        self.circleMembersFetcher?.shutDown()
        
        self.circleMembersFetcher = CircleMembersFetcher(circleID: self.circleID)
        self.circleMembersFetcher?.delegate = self
        self.circleMembersFetcher?.fetchCircleMembers(userIDArray: self.circleMemberArray.map({$0.userID}))
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
            if self.amMember() {
                return 2
            } else {
                return 1
            }
        }
        else if self.sections[section] == .description {
            return 1
        }
        else if self.sections[section] == .members {
            if self.amMember() {
                return self.memberProfileArray.count
            } else {
                return 0
            }
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.sections[section] == .options {
            return self.sections[section].rawValue
        }
        else if self.sections[section] == .description {
            return self.sections[section].rawValue
        }
        else if self.sections[section] == .members {
            if self.circleMemberArray.isEmpty || !self.amMember() {
                return nil
            } else {
                return self.sections[section].rawValue
            }
        }
        else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleInfoCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        if self.sections[indexPath.section] == .options {
            if indexPath.row == 0 {
                if amMember() {
                    cell.textLabel?.text = "Leave"
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.accessoryType = .none
                } else {
                    cell.textLabel?.text = "Join"
                    cell.textLabel?.textColor = Constant.oBlue
                    cell.accessoryType = .none
                }
            } else {
                cell.textLabel?.text = "Notifications"
                cell.detailTextLabel?.text = "Know whenever this group chat is started."
                cell.accessoryView = self.notifsOnSwitcher
                if let myMember = circleMemberArray.first(where: {$0.userID == Auth.auth().currentUser?.uid ?? "nil"}) {
                    self.notifsOnSwitcher.isOn = myMember.notifsOn
                }
            }
        }
        else if self.sections[indexPath.section] == .description {
            cell.textLabel?.numberOfLines = 99
            cell.textLabel?.text = self.circleDescription
            
        }
        else if self.sections[indexPath.section] == .members {
            let user = self.memberProfileArray[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = user.userName
            cell.detailTextLabel?.text = user.userHandle
            
        }
        else { }
        

        return cell
    }
    
    
    
    //MARK: - UTility
    
    func amMember() -> Bool {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return false }
        if circleMemberArray.contains(where: {$0.userID == myUID}) {
            return true
        } else {
            return false
        }
        
    }
    

}
