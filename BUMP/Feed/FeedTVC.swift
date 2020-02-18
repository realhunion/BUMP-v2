//
//  FeedTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 12/4/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import Firebase

class FeedTVC: UITableViewController {
    
    var db = Firestore.firestore()
    
    var feedFetcher : FeedFetcher?
    
    var feedChatArray : [FeedChat] = [] {
        didSet {
            if self.feedChatArray.isEmpty {
                self.setupBackgroundView()
            } else {
                self.tableView.backgroundView = nil
            }
        }
    }
    
    
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.tableView.backgroundColor = Constant.oGrayLight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupFeedFetcher()
        
//        self.setupBackgroundView()
    }
    
    var backgroundLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.numberOfLines = 2
        label.text = "Chats last 24h.\nConnections last forever."
        label.textAlignment = .center
        return label
    }()
    var spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    func setupBackgroundView() {
        self.tableView.backgroundView = self.backgroundLabel
    }
    func setupSpinner() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        self.spinner.startAnimating()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func shutDown() {
        self.feedFetcher?.shutDown()
        self.feedChatArray.removeAll()
        
        self.cellHeights.removeAll()
        self.tableView.reloadData()
    }
    

    func setupTableView() {
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feedCell")
        tableView.register(UnreadFeedCell.self, forCellReuseIdentifier: "newFeedCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0, bottom: 12.0, right: 0)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedChatArray.count
    }
    
    
    //FIX: FUTURE experimental does it effective
    var cellHeights = [IndexPath: CGFloat]()
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        guard let myUID = Auth.auth().currentUser?.uid else { return cell }
        
        let feedChat = self.feedChatArray[indexPath.row]
        
        let numUnreadMessages = feedChat.getMyUserUnreadMsgs()
        if 0 < numUnreadMessages {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "newFeedCell", for: indexPath) as! UnreadFeedCell
            cell1.newMessagesLabel.text = "\(numUnreadMessages)"
            cell = cell1
        }
        
        
        cell.circleTitleLabel.text = feedChat.circleEmoji + " · " + feedChat.circleName
        cell.firstMessageLabel.text = feedChat.getFirstMessage()?.text ?? "🤙"
        cell.timeLabel.text = feedChat.getTimestampString()
        
        
        cell.followButton.isSelected = feedChat.isMyUserFollowing()
        cell.followButtonAction = { [unowned self] in
            
            if cell.followButton.isSelected == false {
                ChatFollower.shared.followChat(chatID: feedChat.chatID)
            } else {
                ChatFollower.shared.unFollowChat(chatID: feedChat.chatID)
            }
        }
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feedChat = self.feedChatArray[indexPath.row]
        let chatID = feedChat.chatID
        
        let circleEmoji = feedChat.circleEmoji
        let circleName = feedChat.circleName
        let circleID = feedChat.circleID
        let firstMsg = feedChat.getFirstMessage()?.text ?? "🤙"
        //FIX: make safer
        
        CircleManager.shared.enterCircle(chatID: chatID, firstMsg: firstMsg, circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        
    }
    
    
    


}
