//
//  CreditsInfoVC.swift
//  BUMP
//
//  Created by Hunain Ali on 2/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation

class CreditsInfoVC : TermsInfoVC {
    
    
    override func setupTextView() {
        if let rtfPath = Bundle.main.url(forResource: "Credits", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                
                self.infoTextView.attributedText = attributedStringWithRtf
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }
    
    
}

class WhatisBumpInfoVC : TermsInfoVC {
    
    override func setupTextView() {
        if let rtfPath = Bundle.main.url(forResource: "WhatIsBump", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                
                self.infoTextView.attributedText = attributedStringWithRtf
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }
    
}

class HowToUseInfoVC : TermsInfoVC {
    
    override func setupTextView() {
        if let rtfPath = Bundle.main.url(forResource: "WhatIsBump", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                
                self.infoTextView.attributedText = attributedStringWithRtf
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }
    
}
