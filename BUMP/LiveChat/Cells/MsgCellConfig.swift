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
    
    
    static let userImageWidth : CGFloat = 30.0
    
    
    static let inBubbleColor = Constant.oGray
    static let outBubbleColor = Constant.oBlue
//    static let oBlueDark = UIColor(red:0.00, green:0.65, blue:1.00, alpha:1.0)
//    static let myGrayColor = UIColor(red:0.905, green:0.91, blue:0.925, alpha:1.0)
    // in RGB
    
    static let msgFont = UIFont.preferredFont(forTextStyle: .body)
    //17.0
    
    
    static let minBubbleWidth : CGFloat = 16.0
    static let maxBubbleWidth : CGFloat = UIScreen.main.bounds.width * 0.6
    
    static let verticalBubblePadding : CGFloat = 8.0
    static let horizontalBubblePadding : CGFloat = 12.5
    // Distance between text inside bubble & edges of bubble. left right and top bottom.
    
    
    
//    static let bubbleGroupSpacing : CGFloat = 6.0
    static let bubbleSpacing : CGFloat = 3.5
    //Bubblespacing is between consecutive bubbles.
    //bubble group is different bubblegroup of different people.
    
    static let inBubbleMargins : UIEdgeInsets = UIEdgeInsets(top: 6.0, left: 15.0, bottom: 6.0, right: 0)
    static let outBubbleMargins : UIEdgeInsets = UIEdgeInsets(top: 6.0, left: 0, bottom: 6.0, right: 10.0)
    // remember this is collectionView, not tableview.
    //think of cells stacked closely together that is overall layout is colletcionvView layout.
    //spacing of left pushes other side of it to the right.
    
}
