//
//  UserDefaultsManager.swift
//  BUMP
//
//  Created by Hunain Ali on 1/21/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation


struct defaultsKeys {
    static let launchSortOption = "launchSortOption"
}


class UserDefaultsManager {
    
    
    static let shared : UserDefaultsManager = UserDefaultsManager()
    
    
    //MARK: - Managing pList
    
    func clearAllData() {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "intro1Shown")
        defaults.removeObject(forKey: "intro2Shown")
        defaults.removeObject(forKey: "myFavLaunchCircles")
        
//        defaults.removeObject(forKey: "lastLaunchTimes")
        //FIX: FUTURE decide what is what
    }
    
    
    //MARK: - INTRO 1
    
    func setMyProfileShown(shown : Bool) {
        let defaults = UserDefaults.standard
        defaults.set(shown, forKey: "intro1Shown")
        
    }
    
    func isMyProfileShown() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "intro1Shown")
    }
    
    
    
    //MARK: - INTRO 2
    
    func setIntroInfoShown(shown : Bool) {
        let defaults = UserDefaults.standard
        defaults.set(shown, forKey: "intro2Shown")
        
    }
    
    func isIntroInfoShown() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "intro2Shown")
    }
    
    
    
    
    //MARK: - My Fav Launch Circles
    
    func tappedLaunchCircle(circleID : String) {
        let defaults = UserDefaults.standard
        
        //Track Fav Circles
        
        var dict = UserDefaultsManager.shared.getMyFavLaunchCircles()
        
        var totalTaps = 1
        if let oldTaps = dict[circleID] {
            totalTaps += oldTaps
        }
        
        dict[circleID] = totalTaps
        defaults.set(dict, forKey: "myFavLaunchCircles")
    
    }
    
    func getMyFavLaunchCircles() -> [String:Int] {
        let defaults = UserDefaults.standard
        
        guard let dict = defaults.dictionary(forKey: "myFavLaunchCircles") as? [String:Int] else {
            return [:]
        }
        return dict
    }
    
    
    
    
    
    // MARK: - Circle Launch Limit
    
    func launchedLaunchCircle(circleID : String) {
        let defaults = UserDefaults.standard
        
        //Last Time Launched Circle
        
        var array = UserDefaultsManager.shared.getLastLaunchTimesArray()
        
        array.removeAll(where: {$0.timeIntervalSinceNow < -3600}) // resets every 1h. only keep track last 1h.
        
        array.insert(Date(), at: 0)
        defaults.set(array, forKey: "lastLaunchTimes")
    }
    
    func getLastLaunchTimesArray() -> [Date] {
        let defaults = UserDefaults.standard
        
        guard let array = defaults.value(forKey: "lastLaunchTimes") as? [Date] else {
            return []
        }
        
        return array
    }
    
    
    
}
