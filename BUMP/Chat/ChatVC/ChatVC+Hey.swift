//
//  ChatVC+Hey.swift
//  BUMP
//
//  Created by Hunain Ali on 1/25/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit

extension ChatVC {
    
    
    @objc func handleHeyButton() {
        
        guard !checkIfHeyTooFast() else { return }
        
        self.sendTextMessage(text: self.circleEmoji)
        
    }
    
    // on the 4th msg in 2 seconds. trigger nope.
    func checkIfHeyTooFast() -> Bool {
        
        if heySpamArray.count < 4 {
            self.heySpamArray.append(Date())
            return false
        }
        guard let hey1 = heySpamArray.first else { return false }
        
        
        let lastHeySeconds = Double(hey1.timeIntervalSince1970)
        let currentDate = Date()
        let currentTime = Double(currentDate.timeIntervalSince1970)
        let difference = currentTime - lastHeySeconds
        if difference < 2 {
            let alert = UIAlertController(title: "Slow down there bud.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return true
        } else {
            self.heySpamArray.remove(at: 0)
            self.heySpamArray.append(currentDate)
        }
        
        return false
        
    }
    
    
    
    
    
    
    
    
    
    
}
