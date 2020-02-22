//
//  LoginView.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/15/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//


import UIKit
import QuickLayout

class LoginView: UIView {
    
    let emailPlaceholder = "Your Email"
    let passwordPlaceholder = "Password"
    
    deinit {
        print("boop deinit loginview1")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bump Grinnell v2"
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy var emailTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.oGrayLight
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 11.0
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
    
    lazy var passTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.oGrayLight
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 11.0
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
    
    lazy var signupCornerButton : UIButton = {
        
        let button = UIButton()
        button.addTarget(self, action: #selector(switchToSignupView), for: .touchUpInside)
        button.setTitleColor(Constant.oBlue.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(Constant.oBlue.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        return button
    }()
    
    
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupPaddingView()
        setupTitleLabel()
        setupLoginButton()
        setupEmailTextField()
        setupPassTextField()
        setupSignupButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var paddingView : UIView = UIView()
    func setupPaddingView() {
        
        addSubview(paddingView)
        paddingView.layoutToSuperview(.top, offset: 40)
        paddingView.layoutToSuperview(.bottom, offset: -40)
        paddingView.layoutToSuperview(.left, offset: 40)
        paddingView.layoutToSuperview(.right, offset: -40)
        
    }
    
    
    func setupTitleLabel() {
        
        paddingView.addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, offset: 0)
        titleLabel.layoutToSuperview(.left, offset: 0)
        
        
    }
    
    func setupSignupButton() {
        
        paddingView.addSubview(signupCornerButton)
        
        signupCornerButton.layout(.left, to: .right, of: titleLabel, offset: 20)
        
        signupCornerButton.layoutToSuperview(.top, offset: 0)
        signupCornerButton.layoutToSuperview(.right, offset: 0)
    }
    
    
    func setupEmailTextField() {
        
        paddingView.addSubview(emailTextField)
        emailTextField.layout(.top, to: .bottom, of: signupCornerButton, offset: 10)
        emailTextField.layout(.top, to: .bottom, of: titleLabel, offset: 10)
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
    
    func setupLoginButton() {
        paddingView.addSubview(loginButton)
        loginButton.layout(.top, to: .bottom, of: passTextField, offset: 10)
        loginButton.layoutToSuperview(.bottom, offset: 0)
        loginButton.layoutToSuperview(.left, offset: 0)
        loginButton.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 40
        loginButton.set(.height, of: height)
    }
    
    
    
    
    
    
//    @objc func loginButtonPressed() {
//        self.loginVC?.loginButtonPressed()
//    }
    
    @objc func switchToSignupView() {
        let x = LoginManager()
        x.presentSignupVC()
    }
    
    
    
    
    
    
    
    
    }



extension LoginView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
    
}
