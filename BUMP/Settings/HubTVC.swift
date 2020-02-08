//
//  Settings.swift
//  BUMP
//
//  Created by Hunain Ali on 11/10/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftEntryKit

struct SettingsCell {
    var title : String
    var image : UIImage?
    var disclosureIndicator : Bool
}

class HubTVC: UITableViewController {
    
//    let settingCellArray : [[SettingsCell]] = [
//        [SettingsCell(title: "Credits", image: nil, disclosureIndicator: true),
//         SettingsCell(title: "Contact Info", image: nil, disclosureIndicator: true),
//         SettingsCell(title: "Privacy & Terms Of Use", image: nil, disclosureIndicator: true)],
//        [SettingsCell(title: "Log Out", image: nil, disclosureIndicator: false)]
//    ]
    
    let settingCellArray : [[SettingsCell]] = [
        
        [SettingsCell(title: "My Profile", image: nil, disclosureIndicator: true),
         SettingsCell(title: "My Circles", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Silence Mode", image: nil, disclosureIndicator: true)],
        
        [SettingsCell(title: "What is Bump?", image: nil, disclosureIndicator: true),
         SettingsCell(title: "How To Use", image: nil, disclosureIndicator: true)],
        
        [SettingsCell(title: "Helpline", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Rules of Bumpland", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Credits", image: nil, disclosureIndicator: true)
        ],
        [SettingsCell(title: "Log Out", image: nil, disclosureIndicator: false)]
        
        //        [SettingsCell(title: "Rules of Bumpland", image: nil, disclosureIndicator: true),
        //         SettingsCell(title: "Credits", image: nil, disclosureIndicator: true),
//         SettingsCell(title: "Log Out", image: nil, disclosureIndicator: false)]
    ]
    
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("noti SETTINGS TVC is deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "settingsCell")
    }
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Account"
        }
        else if section == 1 {
            return "THIS THING"
        }
        else if section == 2 {
            return "info"
        }
        else if section == 3 {
            return "shall you choose"
        }
        else {
            return nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingCellArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingCellArray[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = self.settingCellArray[indexPath.section][indexPath.row].title
        
        if self.settingCellArray[indexPath.section][indexPath.row].disclosureIndicator {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard LoginManager.shared.isLoggedIn() else { return }
        
        let settingsCell = self.settingCellArray[indexPath.section][indexPath.row]
        
        switch settingsCell.title {
            
        case "My Profile":
            self.presentMyProfile()
            
        case "My Circles":
            self.presentMyCircles()
            
        case "Silence Mode":
            self.presentSilenceMenu()
            
        case "What is Bump?":
            self.presentIntroInfo()
            
        case "How To Use":
//            self.presentIntroInfo()
            NotificationManager.shared.presentEnableNotificationsView()
            //FIX:
            
        case "Helpline":
            self.presentHelpline()
            
        case "Credits":
            self.presentCredits()
            
        case "Rules of Bumpland":
            self.presentTerms()
            
        case "Log Out":
            (UIApplication.shared.delegate as! AppDelegate).bump?.logOut()
            
        default:
            break
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}

