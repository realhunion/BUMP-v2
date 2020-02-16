//
//  AnnouncementsManager.swift
//  BUMP
//
//  Created by Hunain Ali on 1/26/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

class AnnouncementsManager {
    
    var userAnnouncementsListener : ListenerRegistration?
    
    static let shared : AnnouncementsManager = AnnouncementsManager()
    
    
    var db = Firestore.firestore()
    

    
    
    //MARK: - Main
    
    func startMonitors() {
        self.monitorUserAnnouncements()
        self.fetchAllAnnouncements()
    }
    
    func shutDown() {
        if let listenr = self.userAnnouncementsListener {
            listenr.remove()
        }
    }
    
    
    
    
    
    //MARK: - Announvements USER
    
    func monitorUserAnnouncements() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.userAnnouncementsListener = db.collection("AnnouncementsToUser").document(myUID).collection("Announcements").addSnapshotListener({ (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            
            for docChange in docChanges {
                
                if docChange.type == .added {
                    
                    let doc = docChange.document
                    
                    guard let msgTitle = doc.data()["msgTitle"] as? String,
                        let msgBody = doc.data()["msgBody"] as? String,
                        let msgType = doc.data()["msgType"] as? String else { continue }
                    
                    
                    if let seen = doc.data()["seen"] as? Bool {
                        if seen {
                            continue
                        }
                    }
                    
                    if msgType == "ban" {
                        self.presentBanAlert(msgTitle: msgTitle, msgBody: msgBody)
                    }
                    else {
                        self.presentUserAnnouncementAlert(announcementID: doc.documentID, msgTitle: msgTitle, msgBody: msgBody)
                    }
                }
                
            }
        })
    }
    
    
    
    func presentUserAnnouncementAlert(announcementID : String, msgTitle : String, msgBody : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let alert = MyAlertController(title: msgTitle, message: msgBody, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("seen 3")
            self.db.collection("AnnouncementsToUser").document(myUID).collection("Announcements").document(announcementID).setData(["seen":true], merge: true)
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
//        MyAlertManager.shared.addToQueue(alert: alert)
        
    }
    
    func presentBanAlert(msgTitle : String, msgBody : String) {
        
        (UIApplication.shared.delegate as! AppDelegate).bump?.logOut()
        let alert = MyAlertController(title: msgTitle, message: msgBody, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            //
        }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
//        MyAlertManager.shared.addToQueue(alert: alert)
        
    }
        
        
        
    
    
    
        
        //MARK: - Announcements ALL
        
        
        func fetchAllAnnouncements() {
            db.collection("AnnouncementsToAll").getDocuments { (snap, err) in
                
                guard let docs = snap?.documents else { return }
                
                for doc in docs {
                    
                    guard let msgTitle = doc.data()["msgTitle"] as? String,
                        let msgBody = doc.data()["msgBody"] as? String  else { continue }
                    
                    self.presentAllAnnouncementAlert(announcementID: doc.documentID, msgTitle: msgTitle, msgBody: msgBody)
                }
                
            }
        }
        
        func presentAllAnnouncementAlert(announcementID : String, msgTitle : String, msgBody : String) {
            
            guard let myUID = Auth.auth().currentUser?.uid else { return }
            
            db.collection("AnnouncementsToAll").document(announcementID).collection("Users").document(myUID).getDocument { (snap, err) in
                guard let doc = snap else { return }
                
                if let seen = doc.data()?["seen"] as? Bool, seen { return }
                
                
                let alert = MyAlertController(title: msgTitle, message: msgBody, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.db.collection("AnnouncementsToAll").document(announcementID).collection("Users").document(myUID).setData(["seen":true], merge: true)
                    }))
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
//                MyAlertManager.shared.addToQueue(alert: alert)
              
            }
        }
        
        
}
