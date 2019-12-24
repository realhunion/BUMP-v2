//
//  ChatVC+NavBar.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/20/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import QuickLayout

extension ChatVC {
    

    func setupNavBar() {
        
        //FIX: v View v View
    
        
        self.view.addSubview(navBar)
        
        self.navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.navBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.navBar.set(.height, of: 44.0)
        
        print("vvs \(self.navBar.bounds.origin.y)")
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        v.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        self.view.insertSubview(v, belowSubview: navBar)
        
        self.navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        self.navBar.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        self.navBar.isTranslucent = false
        self.navBar.setValue(true, forKey: "hidesShadow")
        //FIX
        
        let navItem = UINavigationItem(title: "")
        
        let tlabel = UILabel(frame: CGRect.zero)
        tlabel.text = self.circleName
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont.preferredFont(forTextStyle: .headline)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        
        navItem.titleView = tlabel
        
        
        
        let followChatButtonItem = UIBarButtonItem(customView: followChatButton)
        navItem.setRightBarButton(followChatButtonItem, animated: true)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: backButton.frame.size.width).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: backButton.frame.size.height).isActive = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navItem.setLeftBarButton(backButtonItem, animated: true)
        
        self.navBar.setItems([navItem], animated: true)
        
        
    }
    
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func followChatButtonTapped() {
        print("Follow chat button tapped\n")
        self.followChatButton.isSelected = !self.followChatButton.isSelected
    }
    
    
}
