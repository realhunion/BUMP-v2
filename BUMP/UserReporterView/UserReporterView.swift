//
//  UserReporterVie.swift
//  BUMP
//
//  Created by Hunain Ali on 11/6/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Firebase


class UserReporterView: UIView {
    
    var db = Firestore.firestore()
    
    
    lazy var textField: BaseTextField = {
        let textField = BaseTextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.oGrayLight
        textField.textAlignment = NSTextAlignment.center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 13.0
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        textField.textColor = UIColor.darkText
        
        textField.attributedPlaceholder = NSAttributedString(string: "Please provide comment", attributes: [NSAttributedString.Key.foregroundColor: Constant.textfieldPlaceholderGray])
            
        return textField
    }()
    
    lazy var reportButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(reportButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Report User", for: .normal)
        button.backgroundColor = UIColor.systemRed
        return button
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.black.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = Constant.oGray
        return button
    }()
    
    
    var userID : String!
    var userName : String!
    public init(userID : String, userName : String) {
        super.init(frame: UIScreen.main.bounds)
        
        self.userID = userID
        self.userName = userName
        
        setupTextField()
        setupReportButton()
        setupCancelButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupTextField() {
        addSubview(textField)
        let height: CGFloat = 35
        textField.set(.height, of: height)
        textField.layoutToSuperview(.top, offset: 30)
        textField.layoutToSuperview(.left, offset: 30)
        textField.layoutToSuperview(.right, offset: -30)
        textField.layoutToSuperview(.centerX)
    }
    
    func setupReportButton() {
        
        addSubview(reportButton)
        let height: CGFloat = 40
        reportButton.set(.height, of: height)
        reportButton.layout(.top, to: .bottom, of: textField, offset: 10)
        reportButton.layoutToSuperview(.left, offset: 30)
        reportButton.layoutToSuperview(.right, offset: -30)
        reportButton.layoutToSuperview(.centerX)
    }
    
    func setupCancelButton() {
        
        addSubview(cancelButton)
        let height: CGFloat = 40
        cancelButton.set(.height, of: height)
        cancelButton.layout(.top, to: .bottom, of: reportButton, offset: 10)
        cancelButton.layoutToSuperview(.bottom, offset: -30)
        cancelButton.layoutToSuperview(.left, offset: 30)
        cancelButton.layoutToSuperview(.right, offset: -30)
        cancelButton.layoutToSuperview(.centerX)
        
    }
    
    
}

