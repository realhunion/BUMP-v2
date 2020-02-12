//
//  TermsInfoVC.swift
//  BUMP
//
//  Created by Hunain Ali on 2/8/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit

class TermsInfoVC: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    
    //MARK:- Dismiss
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            
            self.onDismissAction?()
            
        }
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        //        self.dismiss(animated: true, completion: nil)
    }
    
    
    var onDismissAction : (() -> ())?
    
    
    
    //MARK:- MAIN
    
    
    lazy var infoTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        textView.textColor = UIColor.darkGray
        
        textView.backgroundColor = UIColor.white
        
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.isScrollEnabled = true
        
        textView.isEditable = false
        
        textView.showsVerticalScrollIndicator = true
        
        return textView
    }()
    
    lazy var enterButton : UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupTextView()
        self.setupEnterButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.infoTextView.scrollToTop(true)
        self.infoTextView.flashScrollIndicators()
    }
    
    
    
    func setupViews() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(infoTextView)
        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        enterButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        enterButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        enterButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        infoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        infoTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        infoTextView.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -20).isActive = true
        
    }
    
    func setupTextView() {
        if let rtfPath = Bundle.main.url(forResource: "TermsAndConditions", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                
                self.infoTextView.attributedText = attributedStringWithRtf
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }
    
    func setupEnterButton() {
        self.enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
    }
    
    @objc func enterButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
