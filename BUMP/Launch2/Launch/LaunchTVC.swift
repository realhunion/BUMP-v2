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
    
    
    var myCirclesFetcher : MyCirclesFetcher?
    var categoriesFetcher : CategoriesFetcher?
    
    var myCircleArray : [LaunchCircle] = []
    var categoryArray : [CircleCategory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBarButtons()
        self.setupLaunchFetcher()
        self.setupCategoriesFetcher()
        
        self.setupRefreshControl()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "launchCell")
        self.tableView.register(AccessoryTableViewCell.classForCoder(), forCellReuseIdentifier: "categoryCell")
    }
    
    func shutDown() {
        self.categoriesFetcher?.shutDown()
        self.myCirclesFetcher?.shutDown()
        self.myCircleArray = []
        self.categoryArray = []

        NotificationCenter.default.removeObserver(self)
        
        self.tableView.reloadData()
        //FIX: move to Bump file
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.refreshLaunchFetcher()
    }
    
    
    
    //MARK: - Setup
    
    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:  #selector(didRefreshControl), for: .valueChanged)

    }
    
    @objc func didRefreshControl() {
        
        self.refreshLaunchFetcher()
    }
    
    func setupCategoriesFetcher() {
        self.categoriesFetcher = CategoriesFetcher()
        self.categoriesFetcher?.delegate = self
        self.categoriesFetcher?.fetchCategories()
    }
    
    func setupLaunchFetcher() {
        
        self.myCirclesFetcher = MyCirclesFetcher()
        self.myCirclesFetcher?.delegate = self
        self.myCirclesFetcher?.monitorMyCircles()
    }
    
    func refreshLaunchFetcher() {
        self.myCirclesFetcher?.shutDown()
        self.categoriesFetcher?.shutDown()
        self.setupLaunchFetcher()
        self.setupCategoriesFetcher()
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
            return self.myCircleArray.count
        }
        else if section == 1 {
            return self.categoryArray.count
        }
        else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            cell.textLabel?.text = self.categoryArray[row].categoryName
//            cell.detailTextLabel?.text = "\(self.categoryArray[row].numCircles)"
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath)
            cell.accessoryType = .detailButton
            cell.selectionStyle = .none
            
            let c = self.myCircleArray[row]
            
            cell.imageView?.image = self.imageWith(string: c.circleEmoji)
            cell.textLabel?.text = c.circleName
            cell.detailTextLabel?.text = "\(c.memberArray.count) members"
        
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
    

}


