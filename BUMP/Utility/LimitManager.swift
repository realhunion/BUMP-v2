//
//  LimitManager.swift
//  BUMP
//
//  Created by Hunain Ali on 2/21/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit

class LimitManager {
    
    static let shared = LimitManager()
    
    
    
    // MARK: - Is Chat Active? (past 3am)
    
    func isChatActive(circleID : String, circleName : String, circleEmoji : String, timeLaunched : Date) -> Bool {
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(identifier: "America/Chicago") // Japan Standard Time
        dateComponents.hour = 3
        dateComponents.minute = 1
        
        // Create date from components
        guard let someDateTime = Calendar.current.date(from: dateComponents) else { return true }
        
        let dateComps =
            Calendar.current.dateComponents([.hour,
                                     .minute],
                                    from: someDateTime)
        
        guard let nextThreeAm = Calendar.current.nextDate(after: Date(),
                                     matching: dateComps,
                                     matchingPolicy: .strict,
                                     repeatedTimePolicy: .first,
                                     direction: .forward) else { return true }
        
        guard let lastThreeAm = Calendar.current.date(byAdding: DateComponents(day: -1), to: nextThreeAm) else { return true }
        
        
        if lastThreeAm < timeLaunched {
            return true
        } else {
            self.presentChatInactive(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
            return false
        }
    }
    
    func presentChatInactive(circleID : String, circleName : String, circleEmoji : String) {
        let alert = UIAlertController(title: "Sorry, chats last 24h", message: "But you can start a new one 🤙", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let relaunchAction = UIAlertAction(title: "Start \(circleName)", style: .default) { (act) in
            CircleManager.shared.launchCircle(circleID: circleID, circleName: circleName, circleEmoji: circleEmoji)
        }
        alert.addAction(okAction)
        alert.addAction(relaunchAction)
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: - Can Launch Circle? (3/20min reached or not)
    
    // currently maxPer
    func canLaunchCircle() -> Bool { // based off last launches
        
        let maxPerTime = 3 //FIX: THIS
        
        let lastLaunchTimesArray = UserDefaultsManager.shared.getLastLaunchTimesArray()
        
        if lastLaunchTimesArray.count < maxPerTime {
            return true
        } else {
            if lastLaunchTimesArray[maxPerTime-1].timeIntervalSinceNow < -1200 { //20min
                return true
            } else {
                self.presentLaunchLimitReached(limitPerTime : maxPerTime)
                return false
            }
        }
    }
    
    func presentLaunchLimitReached(limitPerTime : Int) {
        let alert = UIAlertController(title: "Sorry, can only start \(limitPerTime) new chats every 20 min", message: "This is to hedge against spam from the bad actors", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    // MARK: - 
    
    
}
