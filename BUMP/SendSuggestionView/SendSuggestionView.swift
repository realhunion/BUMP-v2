//
//  UserSuggestionView.swift
//  BUMP
//
//  Created by Hunain Ali on 11/12/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import Firebase
import QuickLayout
import SwiftEntryKit


class SendSuggestionView: UIView {
    
    
    var db = Firestore.firestore()
    
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        titleLabel.text = "Send a Suggestion! ✊"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    lazy var textField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        
        textField.backgroundColor = Constant.oGrayLight
        let atr = [NSAttributedString.Key.foregroundColor : Constant.textfieldPlaceholderGray]
        textField.attributedPlaceholder = NSAttributedString(string: "New Circles, App Features, anything!", attributes: atr)
        
//        textField.placeholder = "New Clubs, App Improvements, etc."
        textField.textAlignment = NSTextAlignment.center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 13.0
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
        textField.returnKeyType = .search
        
//        textField.delegate = self
        
        return textField
    }()
    
    lazy var sendButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Send", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        return button
    }()
    
    
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupTitleLabel()
        setupTextField()
        setupSearchButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupTitleLabel() {
        
        addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, offset: 30)
        titleLabel.layoutToSuperview(.left, offset: 30)
        titleLabel.layoutToSuperview(.right, offset: -30)
        
    }
    
    func setupTextField() {
        
        addSubview(textField)
        textField.layout(.top, to: .bottom, of: titleLabel, offset: 15)
        textField.layoutToSuperview(.left, offset: 30)
        textField.layoutToSuperview(.right, offset: -30)
        
        let height: CGFloat = 35
        textField.set(.height, of: height)
    }
    
    func setupSearchButton() {
        
        addSubview(sendButton)
        let height: CGFloat = 40
        sendButton.set(.height, of: height)
        sendButton.layout(.top, to: .bottom, of: textField, offset: 10)
        sendButton.layoutToSuperview(.bottom, offset: -30)
        sendButton.layoutToSuperview(.left, offset: 30)
        sendButton.layoutToSuperview(.right, offset: -30)
        sendButton.layoutToSuperview(.centerX)
    }
    
    
}









extension SendSuggestionView : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendButtonTapped()
        return true
    }
    
    @objc func sendButtonTapped() {
        
        guard let suggestionText = self.textField.text else {
            SwiftEntryKit.dismiss()
            return
        }
        
        if suggestionText == "" {
            SwiftEntryKit.dismiss()
            return
        }
        
        let payload = ["suggestion": suggestionText,
                       "timestamp": Timestamp(date: Date())
            ] as [String : Any]
        
        self.sendButton.isEnabled = false
        self.sendButton.setTitle("Sending...", for: .normal)
        db.collection("Suggestions-Users").addDocument(data: payload) { (err) in
            SwiftEntryKit.dismiss()
            return
        }
        
        
    }

    
    
    
    
    
}
