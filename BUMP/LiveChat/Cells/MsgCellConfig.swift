//
//  MsgCellConfig.swift
//  BUMP
//
//  Created by Hunain Ali on 10/23/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation
import UIKit

enum MsgCellConfig {
   
    // username label
    static let userNameFont : UIFont = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
    static let userNameColor = UIColor.gray
    
    
    static let userImageWidth : CGFloat = 25.0
    
    
    static let inBubbleColor = Constant.oGray
    static let outBubbleColor = Constant.oBlue
//    static let oBlueDark = UIColor(red:0.00, green:0.65, blue:1.00, alpha:1.0)
//    static let myGrayColor = UIColor(red:0.905, green:0.91, blue:0.925, alpha:1.0)
    // in RGB
    
    static let msgFont = UIFont.preferredFont(forTextStyle: .body)
    //17.0
    
    static let minBubbleWidth : CGFloat = 16.0
    static let maxBubbleWidth : CGFloat = UIScreen.main.bounds.width * 0.6
    
    static let topBottomBubbleSpacing : CGFloat = 8.0
    static let leftRightBubbleSpacing : CGFloat = 12.5
    // Distance between text inside bubble & edges of bubble. left right and top bottom.
    
    static let incomingBubbleMargin : CGFloat = 15.0
    static let outgoingBubbleMargin : CGFloat = 10.0
    // incoming left margin of bubble.
    // outgoing right margin of bubble.
    
    
    
}
