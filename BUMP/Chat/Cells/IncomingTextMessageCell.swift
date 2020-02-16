//
//  IncomingTextMessageCell.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage
import FirebaseAuth
import SwiftEntryKit

class IncomingTextMessageCell: BaseMessageCell {
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let x = MsgCellConfig.userImageWidth
        imageView.frame.size = CGSize(width: x, height: x)
        imageView.layer.cornerRadius = MsgCellConfig.userImageWidth/2
        imageView.clipsToBounds = true
        imageView.contentMode = ContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var nameLabel: InsetLabel = {
        let nameLabel = InsetLabel()
        nameLabel.contentInsets = UIEdgeInsets(top: 0, left: MsgCellConfig.horizontalBubblePadding, bottom: 0, right: 0)
        nameLabel.font = MsgCellConfig.userNameFont
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        nameLabel.textColor = MsgCellConfig.userNameColor
        return nameLabel
    }()
    
    var userImageAction : (() -> ())?
    @IBAction func userImageTapped(_ sender: UITapGestureRecognizer) {
        self.userImageAction?()
    }
    
    
    func setupCell(message: Message, isUserImageEnabled: Bool, isUserNameEnabled:Bool) {
        
        self.textView.text = message.text
        self.textView.textColor = UIColor.black
        self.bubbleView.backgroundColor = MsgCellConfig.inBubbleColor
        
        let msgFrame = estimateFrameForText(message.text, textFont: MsgCellConfig.msgFont, maxWidth: MsgCellConfig.maxBubbleWidth)
        
        
        if msgFrame.width <= MsgCellConfig.minBubbleWidth {
            textView.textAlignment = NSTextAlignment.center
        }
        
        
        
        if isUserImageEnabled {
            imageView.isHidden = false
            imageView.frame.origin = CGPoint(x: 0.0, y: frame.height - imageView.frame.height)
            
            let imageRef = Storage.storage().reference(withPath: "User-Profile-Images/\(message.userID).jpg")
            
            let placeHolder = UIImage(color: MsgCellConfig.inBubbleColor)
            self.imageView.setImage(with: imageRef, placeholder: placeHolder)
            
            let tap = StringTapGestureRecognizer(target: self, action: #selector(self.userImageTapped))
            tap.stringTag = message.userID
            self.imageView.addGestureRecognizer(tap)
        } else {
            imageView.isHidden = true
        }
        
        
        
        
        if isUserNameEnabled {
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let dateString = formatter.string(from: message.timestamp.dateValue())
            
            nameLabel.text = message.userName + " · " + dateString
            
            let usernameFrame = estimateFrameForText(message.userName, textFont: MsgCellConfig.msgFont, maxWidth: MsgCellConfig.maxBubbleWidth)
            
            nameLabel.frame.size = CGSize(width: MsgCellConfig.maxBubbleWidth, height: usernameFrame.height)
            nameLabel.frame.origin = CGPoint(x: 0.0 + imageView.bounds.width + 10.0, y: 0)
            
            bubbleView.frame = CGRect(x: 0.0 + imageView.bounds.width + 10.0,
                                      y: nameLabel.frame.height + 0.0,
                                      width: msgFrame.width + (MsgCellConfig.horizontalBubblePadding * 2),
                                      height: frame.size.height - nameLabel.frame.height - 0.0).integral
            textView.frame = CGRect(x: 0, y: 0, width: bubbleView.frame.width, height: bubbleView.frame.height)
            
        }
        else {
            bubbleView.frame = CGRect(x: 0.0 + imageView.bounds.width + 10.0,
                                      y: 0,
                                      width: msgFrame.width + (MsgCellConfig.horizontalBubblePadding * 2),
                                      height: frame.size.height).integral
            textView.frame = CGRect(x: 0, y: 0, width: bubbleView.frame.width, height: bubbleView.frame.height)
        }
        
        
        textView.sizeToFit()
        
    }
    
    
    
    
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(textView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    override func prepareViewsForReuse() {
        super.prepareViewsForReuse()
        textView.textAlignment = NSTextAlignment.natural
        textView.text = ""
        nameLabel.text = ""
        imageView.image = nil
        
    }
    
    
    
}













