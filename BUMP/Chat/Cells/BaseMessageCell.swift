//
//  BaseMessageCell.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit

class BaseMessageCell: UICollectionViewCell {
    
    lazy var bubbleView: UIImageView = {
        let bubbleView = UIImageView()
        bubbleView.backgroundColor = MsgCellConfig.outBubbleColor
        bubbleView.isUserInteractionEnabled = true
        bubbleView.layer.cornerRadius = 18.0
        bubbleView.layer.masksToBounds = true
        return bubbleView
    }()
    
    lazy var textView: BaseTextView = {
        let textView = BaseTextView()
        textView.font = MsgCellConfig.msgFont
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        let x = MsgCellConfig.horizontalBubblePadding
        let y = MsgCellConfig.verticalBubblePadding
        textView.textContainerInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = [.link]
        textView.textColor = UIColor.black
        
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame.integral)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
    }
    
    func prepareViewsForReuse() {}
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareViewsForReuse()
    }
    
}




extension UIViewController {
    //FIX move to MsgCellConfig as static functino
    func estimateFrameForText(_ text: String, textFont : UIFont, maxWidth : CGFloat = 100000, maxHeight : CGFloat = 100000) -> CGRect {
        let size = CGSize(width: maxWidth, height: maxHeight)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: textFont]
        let x = text.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        return CGRect(origin: x.origin, size: CGSize(width: CGFloat.maximum(x.width, MsgCellConfig.minBubbleWidth), height: x.height))
    }
    
}

extension UIView {
    
    func estimateFrameForText(_ text: String, textFont : UIFont, maxWidth : CGFloat = 100000, maxHeight : CGFloat = 100000) -> CGRect {
        let size = CGSize(width: maxWidth, height: maxHeight)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: textFont]
        let x = text.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        return CGRect(origin: x.origin, size: CGSize(width: CGFloat.maximum(x.width, MsgCellConfig.minBubbleWidth), height: x.height))
    }
    
}



class InsetLabel: UILabel {
    
    var contentInsets = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }
    
    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
}

class BaseTextView : UITextView {
    
    override var canBecomeFirstResponder: Bool {
        return false
    }

    
}
