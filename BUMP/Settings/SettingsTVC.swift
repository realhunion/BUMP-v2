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

class SettingsTVC: UITableViewController {
    
    let settingCellArray : [[SettingsCell]] = [
        [SettingsCell(title: "My Profile", image: nil, disclosureIndicator: true)],
        [SettingsCell(title: "Credits", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Contact Info", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Privacy & Terms Of Use", image: nil, disclosureIndicator: true)],
        [SettingsCell(title: "Log Out", image: nil, disclosureIndicator: false)]
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        
        self.tableView.backgroundColor = Constant.oGray
        self.tableView.backgroundView = nil
        
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingCellArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingCellArray[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        cell.accessoryType = .none
        
        cell.backgroundColor = UIColor.white
        
        cell.textLabel?.text = self.settingCellArray[indexPath.section][indexPath.row].title
        cell.textLabel?.textColor = UIColor.black
        
        if let image = self.settingCellArray[indexPath.section][indexPath.row].image {
            cell.imageView?.image = image
        }
        
        if self.settingCellArray[indexPath.section][indexPath.row].disclosureIndicator {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        guard let myUsername = Auth.auth().currentUser?.displayName else { return }
        
        let settingsCell = self.settingCellArray[indexPath.section][indexPath.row]
        
        switch settingsCell.title {
            
        case "My Profile":
            
            let nvc = UINavigationController(rootViewController: self)
            nvc.view.layer.cornerRadius = 18.0
            nvc.view.layer.masksToBounds = true
            var attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
            attributes.precedence = .enqueue(priority: .low)
            SwiftEntryKit.display(entry: nvc, using: attributes)
            
            
            let vc = UserProfileView(userID: myUID, actionButtonEnabled: true)
            let atr = Constant.bottomPopUpAttributes
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: vc, using: atr)
            }
            
            
        case "Credits":
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            vc.edgesForExtendedLayout = []
            
            if let rtfPath = Bundle.main.url(forResource: "Credits", withExtension: "rtf") {
                do {
                    let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                    
                    let infoView = InfoTextView(text: "Credits")
                    infoView.textView.attributedText = attributedStringWithRtf
                    vc.view.addSubview(infoView)
                    infoView.frame = self.view.frame
                    vc.title = "Credits"
                    
                } catch let error {
                    print("Got an error \(error)")
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Contact Info":
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            vc.edgesForExtendedLayout = []
            
            let infoView = InfoTextView(text: "Hello \(myUsername),\n\nIf you have any questions, concerns, feedback, anything:\nLet us know, we'd love to hear it!\n\ntheBumpInitiative@gmail.com")
            vc.view.addSubview(infoView)
            infoView.frame = self.view.frame
            vc.title = "Contact Info"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Privacy & Terms Of Use":
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            vc.edgesForExtendedLayout = []
            
            if let rtfPath = Bundle.main.url(forResource: "TermsAndConditions", withExtension: "rtf") {
                do {
                    let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                    
                    let infoView = InfoTextView(text: "Privacy")
                    infoView.textView.attributedText = attributedStringWithRtf
                    vc.view.addSubview(infoView)
                    infoView.frame = self.view.frame
                    vc.title = "Privacy & Terms Of Use"
                    
                } catch let error {
                    print("Got an error \(error)")
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Log Out":
            
            (UIApplication.shared.delegate as! AppDelegate).bump?.logOut()
            
        default:
            break
            // do none
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}

