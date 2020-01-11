//
//  UserCirclesTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 1/9/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit

class UserCirclesTVC: UITableViewController {
    
    var userCirclesFetcher : UserCirclesFetcher?
    
    
    var circleArray : [Circle] = []
    
    
    var userID : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUserCirclesFetcher()
        
        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "cCell")
        
        self.tableView.contentInset = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
    }

    func setupUserCirclesFetcher() {
        self.userCirclesFetcher = UserCirclesFetcher(userID: self.userID)
        self.userCirclesFetcher?.delegate = self
        self.userCirclesFetcher?.fetchUserCircles()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.circleArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cCell", for: indexPath)
//        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        let circle = self.circleArray[indexPath.row]
        
        cell.textLabel?.text = circle.circleEmoji + "  ·  " + circle.circleName
//        cell.textLabel?.font = UIFont.systemFont(ofSize: cell.textLabel?.font.pointSize ?? 16.0, weight: .medium)
//        cell.detailTextLabel?.text = "              53 members"
//        cell.detailTextLabel?.textColor = Constant.oBlue

        let number = Int.random(in: 3...140)
        cell.detailTextLabel?.text = "\(number)"
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40.0
//    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Following"
//    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let l = UILabel()
//        l.text = "Following"
//        l.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
//        return l
//    }
//    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let circle = circleArray[indexPath.row]
        CircleManager.shared.launchCircle(circleID: circle.circleID, circleName: circle.circleName, circleEmoji: circle.circleEmoji)
    }

}


extension UserCirclesTVC : UserCirclesFetcherDelegate {
    
    
    func userCirclesFetched(circleArray: [Circle]) {
        print("bopp \(circleArray.count)")
        self.circleArray = circleArray
        self.tableView.reloadData()
    }
    
}
