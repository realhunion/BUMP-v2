//
//  OutgoingTextMessageCell.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit

class OutgoingTextMessageCell: BaseMessageCell {

    
    func setupCell(message: Message) {
        
        self.textView.text = message.text
        self.textView.textColor = UIColor.white
        self.bubbleView.backgroundColor = MsgCellConfig.outBubbleColor
        
        let msgFrame = estimateFrameForText(message.text, textFont: MsgCellConfig.msgFont, maxWidth: MsgCellConfig.maxBubbleWidth)
        
        if(msgFrame.width <= MsgCellConfig.minBubbleWidth) {
            textView.textAlignment = NSTextAlignment.center
        }
        
        
        bubbleView.frame = CGRect(x: frame.width - msgFrame.width - 35,
                                  y: 0,
                                  width: msgFrame.width + (MsgCellConfig.leftRightBubbleSpacing * 2),
                                  height: frame.size.height).integral
        textView.frame = CGRect(x: 0, y: 0, width: bubbleView.frame.width, height: bubbleView.frame.height)
    
    }
    
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(textView)
    }
    
    override func prepareViewsForReuse() {
        super.prepareViewsForReuse()
        textView.textAlignment = NSTextAlignment.natural
        textView.text = ""
    }
    
    

    
}
