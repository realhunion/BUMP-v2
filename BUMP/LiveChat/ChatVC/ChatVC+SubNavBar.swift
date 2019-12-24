//
//  ChatVC+UsersHereBar.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/20/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit
import FirebaseAuth
import QuickLayout

extension ChatVC {
    
    
    
    func setupSubNavBar() {
        
        let yy = 0.096 * self.view.bounds.width
        
        self.view.addSubview(subNavBar)
        //FIX
        
        self.subNavBar.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        self.subNavBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.subNavBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.subNavBar.set(.height, of: yy)
        
        let size = CGSize(width: self.view.bounds.width, height: yy) //36
        let origin = CGPoint(x: 0, y: self.navBar.frame.maxY)
        let frame = CGRect(origin: origin, size: size)
        
        self.subNavBar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
//        self.subNavBar.frame = frame
        
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - 0.6, width: frame.size.width, height: 0.6)
        self.subNavBar.layer.addSublayer(border)
        
        
        
        
        
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        
        label.text = self.chatName
        
        self.subNavBar.addSubview(label)
        label.layoutToSuperview(.left, offset: 20)
        label.layoutToSuperview(.right, offset: -20)
        label.layoutToSuperview(.top, offset: 0)
        label.layoutToSuperview(.bottom, offset: -10)
        
    }
    
    
    
    
    
    
    
    
    // MARK:- Delegate Methods
    
    
    
}
