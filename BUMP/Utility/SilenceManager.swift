//
//  SilenceManager.swift
//  BUMP
//
//  Created by Hunain Ali on 2/3/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SilenceManager {
    
    
    static let shared = SilenceManager()
    
    var db = Firestore.firestore()
    
    
    
    
    //MARK:- Main
    
    
    func presentSilenceMenu() {
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let alert = UIAlertController(title: "Silence for:", message: "You will recieve no notifications for time picked.", preferredStyle: .alert)
        
        // Create the actions
        let silence12h = UIAlertAction(title: "12 hours", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.silenceFor(numHours: 12)
            
        }
        let silence3h = UIAlertAction(title: "3 hours", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.silenceFor(numHours: 3)
            
        }
        let silence1h = UIAlertAction(title: "1 hour", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.silenceFor(numHours: 1)
        }
        let unsilence = UIAlertAction(title: "Unsilence", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.unSilence()
        }
        
        alert.addAction(silence1h)
        alert.addAction(silence3h)
        alert.addAction(silence12h)
        alert.addAction(unsilence)
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    
    
    func silenceFor(numHours : Int) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let t = Calendar.current.date(byAdding: .hour, value: numHours, to: Date())
        var data : [String : Any] = [:]
        data["silenceUntil"] = t
        self.db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
        }
        
    }
    
    func unSilence() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        var data : [String : Any] = [:]
        data["silenceUntil"] = FieldValue.delete()
        self.db.collection("User-Base").document(myUID).updateData(data) { (err) in
        }
    }
    
    
    
    
}
