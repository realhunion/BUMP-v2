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
    
    var feedChatArray : [FeedChat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feedCell")
        tableView.register(UnreadFeedCell.self, forCellReuseIdentifier: "newFeedCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        self.feedFetcher = FeedFetcher()
        self.feedFetcher?.startMonitor()
        self.feedFetcher?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0)
    }
    
    

    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedChatArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        guard let myUID = Auth.auth().currentUser?.uid else { return cell }
        
        let feedChat = self.feedChatArray[indexPath.row]
        
        let numUnreadMessages = feedChat.getNumUnreadMessages()
        if numUnreadMessages != 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "newFeedCell", for: indexPath) as! UnreadFeedCell
            cell1.newMessagesLabel.text = "\(numUnreadMessages)"
            cell = cell1
        }
        
        
        cell.circleTitleLabel.text = feedChat.circleEmoji + " · " + feedChat.circleName
        cell.firstMessageLabel.text = feedChat.getFirstMessage()?.text ?? "🤙"
        cell.timeLabel.text = feedChat.getTimestampString()
        
        
        cell.followButton.isSelected = feedChat.myUser.isFollowing ?? false
        cell.followButtonAction = { [unowned self] in
            
            if cell.followButton.isSelected == false {
                self.db.collection("Feed").document(feedChat.chatID).collection("Users").document(myUID).setData(["isFollowing":true] as [String:Any], merge: true)
            } else {
                self.db.collection("Feed").document(feedChat.chatID).collection("Users").document(myUID).setData(["isFollowing":false] as [String:Any], merge: true)
            }
        }
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let feedChat = self.feedChatArray[indexPath.row]
        let chatID = feedChat.chatID
        
        let circleName = feedChat.circleName
        let circleID = feedChat.circleID
        let firstMsg = feedChat.getFirstMessage()!
        
        CircleManager.shared.enterCircle(chatID: chatID, chatName: firstMsg.text, circleID: circleID, circleName: circleName)
        
        
        CircleManager.shared.updateFeedLastSeen(chatID: chatID)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    


}
