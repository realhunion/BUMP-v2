//
//  SignupView.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/14/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import QuickLayout
import SwiftEntryKit
import Firebase

class SignupView: UIView {
    
    let db = Firestore.firestore()
    
    let namePlaceholder = "Your Name"
    let emailPlaceholder = "Your .edu Email"
    let passwordPlaceholder = "Choose a Password"
    
    deinit {
        print("boop deinit signupview")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bump Grinnell 2.0"
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy var nameTextField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.oGrayLight
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        textField.textColor = UIColor.darkText
        
        textField.attributedPlaceholder = NSAttributedString(string: self.namePlaceholder, attributes: [NSAttributedString.Key.foregroundColor: Constant.textfieldPlaceholderGray])
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor

        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var emailTextField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.oGrayLight
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        textField.textColor = UIColor.darkText
        
        textField.attributedPlaceholder = NSAttributedString(string: self.emailPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: Constant.textfieldPlaceholderGray])
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor

        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var passTextField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.oGrayLight
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        textField.textColor = UIColor.darkText
        
        textField.attributedPlaceholder = NSAttributedString(string: self.passwordPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: Constant.textfieldPlaceholderGray])
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        textField.isSecureTextEntry = true
        
        textField.delegate = self
        
        
        return textField
    }()
    
    lazy var signupButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Sign Up!", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        return button
    }()
    
    lazy var loginCornerButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(switchToLoginView), for: .touchUpInside)
        button.setTitleColor(Constant.oBlue.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(Constant.oBlue.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    lazy var detailLabel : UILabel = {
        let label = UILabel()
        label.text = "For Grinnell Students. By Grinnell Students."
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .medium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var privacyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Privacy & Terms Of Use", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .medium)
        button.setTitleColor(Constant.oBlueLight.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(Constant.oBlueLight.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        //FIX
        
        return button
    }()
    
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupPaddingView()
        setupTitleLabel()
        setupLoginCornerButton()
        setupNameTextField()
        setupEmailTextField()
        setupPassTextField()
        setupSignupButton()
        setupDetailLabel()
        setupPrivacyButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var paddingView : UIView = UIView()
    func setupPaddingView() {
        
        addSubview(paddingView)
        paddingView.layoutToSuperview(.top, offset: 40)
        paddingView.layoutToSuperview(.bottom, offset: -30)
        paddingView.layoutToSuperview(.left, offset: 40)
        paddingView.layoutToSuperview(.right, offset: -40)
        
    }
    
    
    func setupTitleLabel() {
        
        paddingView.addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, offset: 0)
        titleLabel.layoutToSuperview(.left, offset: 0)
        
    }
    
    func setupLoginCornerButton() {
        paddingView.addSubview(loginCornerButton)
        
        loginCornerButton.layout(.left, to: .right, of: titleLabel, offset: 20)
        
        loginCornerButton.layoutToSuperview(.top, offset: 0)
        loginCornerButton.layoutToSuperview(.right, offset: 0)
    }
    
    func setupNameTextField() {
        
        paddingView.addSubview(nameTextField)
        nameTextField.layout(.top, to: .bottom, of: loginCornerButton, offset: 10)
        nameTextField.layout(.top, to: .bottom, of: titleLabel, offset: 10)
        nameTextField.layoutToSuperview(.left, offset: 0)
        nameTextField.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 35
        nameTextField.set(.height, of: height)
    }
    
    func setupEmailTextField() {
        
        paddingView.addSubview(emailTextField)
        emailTextField.layout(.top, to: .bottom, of: nameTextField, offset: 10)
        emailTextField.layoutToSuperview(.left, offset: 0)
        emailTextField.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 35
        emailTextField.set(.height, of: height)
    }
    
    func setupPassTextField() {
        
        paddingView.addSubview(passTextField)
        passTextField.layout(.top, to: .bottom, of: emailTextField, offset: 10)
        passTextField.layoutToSuperview(.left, offset: 0)
        passTextField.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 35
        passTextField.set(.height, of: height)
    }
    
    func setupSignupButton() {
        
        paddingView.addSubview(signupButton)
        signupButton.layout(.top, to: .bottom, of: passTextField, offset: 10)
        signupButton.layoutToSuperview(.left, offset: 0)
        signupButton.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 40
        signupButton.set(.height, of: height)
    }
    
    func setupDetailLabel() {
        
        paddingView.addSubview(detailLabel)
        detailLabel.layout(.top, to: .bottom, of: signupButton, offset: 20)
        detailLabel.layoutToSuperview(.left, offset: 0)
        detailLabel.layoutToSuperview(.right, offset: 0)
        
    }
    
    func setupPrivacyButton() {
        paddingView.addSubview(privacyButton)
        
        privacyButton.layout(.top, to: .bottom, of: detailLabel, offset: 0)
        
        privacyButton.layoutToSuperview(.right, offset: 0)
        privacyButton.layoutToSuperview(.left, offset: 0)
        privacyButton.layoutToSuperview(.bottom, offset: 0)
    }
    
    
    
    
    
    
    
//    @objc func signupButtonPressed() {
//        self.loginVC?.signupButtonPressed()
//        
//    }
    
    @objc func switchToLoginView() {
       let x = LoginManager()
        x.presentLoginVC()
    }
    
    var privacyView = InfoTextView(text: "Privacy")
    @objc func privacyButtonTapped() {
        self.emailTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.passTextField.resignFirstResponder()
        
        if let rtfPath = Bundle.main.url(forResource: "TermsAndConditions", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                
                let v = InfoTextView(text: "Privacy")
                v.textView.attributedText = attributedStringWithRtf
                var atribute = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
                SwiftEntryKit.display(entry: v, using: atribute)
                
                
//                let vc = UIViewController()
//                self.removeFromSuperview()
//                vc.view = self
//                var atr = Constant.centerPopUpAttributes
//                let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
//                let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
//                atr.positionConstraints.keyboardRelation = keyboardRelation
//                atr.precedence = .enqueue(priority: .high)
//                SwiftEntryKit.display(entry: self, using: atr)
                
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
        
        
    }
        
    

    
}



extension SignupView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
}
