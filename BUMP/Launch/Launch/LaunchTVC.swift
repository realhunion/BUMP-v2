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


struct CircleCategory {
    var categoryName : String
    var categoryID : String
    var numCircles : Int
}


class LaunchTVC: UITableViewController {
    
    let myFavLaunchCircles = UserDefaultsManager.shared.getMyFavLaunchCircles()
    
    var allCirclesFetcher : AllCirclesFetcher?
    
    var circleArray : [LaunchCircle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSpinner()
        self.setupRefreshControl()
        self.setupBarButtons()
        
        self.setupLaunchFetcher()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "launchCell")
        self.tableView.register(AccessoryTableViewCell.classForCoder(), forCellReuseIdentifier: "categoryCell")
        
//        self.refreshControl?.beginRefreshingManually()
    }
    
    func shutDown() {
        NotificationCenter.default.removeObserver(self)
        
        self.allCirclesFetcher?.shutDown()
        self.circleArray.removeAll()
        self.tableView.reloadData()
        
        self.tableView.backgroundView = nil
    }
    
    
    
    //MARK: - Setup
    
    func setupSpinner() {
        
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        self.tableView.backgroundView = spinner
        spinner.startAnimating()
    }
    
    func setupRefreshControl() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:  #selector(didRefreshControl), for: .valueChanged)

    }
    
    @objc func didRefreshControl() {
        self.refreshLaunchFetcher()
    }
    
    func setupLaunchFetcher() {
        
        self.allCirclesFetcher = AllCirclesFetcher()
        self.allCirclesFetcher?.delegate = self
        self.allCirclesFetcher?.fetchAllCircles()
    }
    
    func refreshLaunchFetcher() {
        
        self.allCirclesFetcher?.shutDown()
        self.setupLaunchFetcher()
    }
    
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
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.getMyCircles().count
        }
        else if section == 1 {
            return self.getCategoryArray().count
        }
        else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath)
            cell.accessoryType = .detailButton
            cell.selectionStyle = .none
            
            let c = self.getMyCircles()[row]
            
            cell.imageView?.image = self.imageWith(string: c.circleEmoji)
            cell.textLabel?.text = c.circleName
            cell.detailTextLabel?.text = "\(c.memberArray.count) members"
            
            return cell
        }
        else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            let category = self.getCategoryArray()[row]
            cell.textLabel?.text = category
            cell.detailTextLabel?.text = "\(self.getCategoryCircleArray(category: category).count)"
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath)
        
            return cell
        }
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
            return "My Group Chats"
        }
        else if section == 1 {
            return "All"
        }
        else {
            return nil
        }
    }
    
    
    
    var selectedVC : CategoryTVC? = nil

}



extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: false)
        }
        beginRefreshing()
    }
}
