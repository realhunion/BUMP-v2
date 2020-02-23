//
//  MyAlertManager.swift
//  BUMP
//
//  Created by Hunain Ali on 1/26/20.
//  Copyright © 2020 BUMP. All rights reserved.
//
import Foundation
import UIKit



class MyAlertController : UIAlertController {
    
    var onDismissAction : (() -> ())?
    var onShowAction : (() -> ())?
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.onDismissAction?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onShowAction?()
    }
    
}

class MyAlertManager {
    
    
    static let shared : MyAlertManager = MyAlertManager()
    
    var alertQueue : [MyAlertController] = [] // [<<<older & newer>>>]
    
    
    func clearQueue() {
        self.alertQueue = []
    }
    
    func addToQueue(alert : MyAlertController) {
        
        self.alertQueue.append(alert)
        if isPresenting == false {
            self.presentAlerts()
        }
        
    }
    
    var isPresenting = false
    func presentAlerts() {
        
        guard let alert = self.alertQueue.popLast() else { isPresenting = false; return }
        isPresenting = true
        
        alert.onDismissAction = { [unowned self] in
            self.presentAlerts()
        }
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
}
