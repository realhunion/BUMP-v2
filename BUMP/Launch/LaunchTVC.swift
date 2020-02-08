//
//  LaunchTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 1/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit
import QuickLayout
import SwiftEntryKit

class LaunchTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let refreshControl = UIRefreshControl()
    
    var tableView : UITableView!
    
    
    var launchFetcher : LaunchFetcher?
    
    var circleArray : [[LaunchCircle]] = [[],[]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupBarButtons()
        self.setupLaunchFetcher()
    }
    
    func shutDown() {
        self.launchFetcher?.shutDown()
        self.circleArray = [[], []]

        NotificationCenter.default.removeObserver(self)
        
                self.tableView.reloadData()
    }

    
    
    //MARK: - Setup
    
    func setupBarButtons() {
        
        let btn1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        let btn2 = UIBarButtonItem(title: "Aa↓", style: .plain, target: self, action: #selector(sortButtonTapped))
        self.navigationItem.setRightBarButtonItems([btn1, btn2], animated: true)
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
    
    func setupTableView() {
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.layoutTableView()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "launchCell")
    }
    func layoutTableView() {
        self.view.addSubview(tableView)
        tableView.layoutToSuperview(.top, offset: 0)
        tableView.layoutToSuperview(.left, offset: 0)
        tableView.layoutToSuperview(.right, offset: 0)
        tableView.layoutToSuperview(.bottom, offset: 0)
    }
    
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return circleArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circleArray[section].count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath)
        cell.accessoryType = .detailButton
        cell.selectionStyle = .none
        
        let c = circleArray[indexPath.section][indexPath.row]
        
        cell.imageView?.image = self.imageWith(string: c.circleEmoji)
        cell.textLabel?.text = c.circleName
        
        
        var followString = "· Join"
        if c.amFollowing() {
            followString = ""
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
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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


class SubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.textLabel?.textColor = UIColor.black
        self.detailTextLabel?.textColor = UIColor.black
        self.imageView?.image = nil
        
        self.textLabel?.text = ""
        self.detailTextLabel?.text = ""
        
        self.accessoryView = nil
        self.accessoryType = .none
    }
}
