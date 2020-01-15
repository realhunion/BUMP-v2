//
//  UpdateManager.swift
//  BUMP
//
//  Created by Hunain Ali on 1/13/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit

class UpdateManager {
    
    static let shared : UpdateManager = UpdateManager()
    
    var db = Firestore.firestore()
    
    
    //MARK: - Shut Down
    
    
    //MARK: - Check
    
    func checkForUpdates() {
        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        db.collection("AppInfo").document("Apple").getDocument { (snap, err) in
            guard let doc = snap else { return }
            guard let appStoreLink = doc.data()?["appStoreLink"] as? String else { return }
            
            if let forceVersion = doc.data()?["forceUpdate"] as? String {
                
                if version < forceVersion {
                    self.presentForceUpdate(forceVersion: forceVersion, appStoreLink: appStoreLink)
                    return
                }
                
            }
            
            if let recommendedVersion = doc.data()?["recommendedUpdate"] as? String{
                
                if version < recommendedVersion {
                    self.presentRecommendedUpdate(recommendedVersion: recommendedVersion, appStoreLink: appStoreLink)
                    return
                }
                
            }
        }
    }
    
    
    //MARK: - Present
    
    func presentForceUpdate(forceVersion : String, appStoreLink : String) {
        
        let alert = UIAlertController(title: "Critical Update Available", message:"Please update your phone to get the latest & greatest.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            if let url = URL(string: appStoreLink), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: {(success: Bool) in
                    if success {
                        print("\(url) launced successfully")
                    }})
            }
        }
        alert.addAction(okAction)
        
        SwiftEntryKit.dismiss(.all)
        UIApplication.topViewController()?.dismiss(animated: true, completion: {
            UIApplication.topViewController()?.present(alert, animated: true)
        })
        
        
        
    }
    
    func presentRecommendedUpdate(recommendedVersion : String, appStoreLink : String) {
        
        //FIX: pList record checked. so it don't popup over and over again.
        let alert = UIAlertController(title: "New Update Available", message:"Please update your phone to get the latest & greatest.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            if let url = URL(string: appStoreLink), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: {(success: Bool) in
                    if success {
                        print("\(url) launced successfully")
                    }})
            }
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Later", style: .destructive, handler: nil))
        
        UIApplication.topViewController()?.dismiss(animated: true, completion: {
            UIApplication.topViewController()?.present(alert, animated: true)
        })
        
    }
    
}
