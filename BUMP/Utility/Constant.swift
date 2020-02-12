//
//  Constant.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import SwiftEntryKit


class IndexTapGestureRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}


class StringTapGestureRecognizer: UITapGestureRecognizer {
    var stringTag: String?
}

extension UILabel {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -4, bottom: -10, right: -10)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}


//FIX: UIBUTTON INCREASED TAP RADIUS
extension UIButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}


extension Date {
    var millisecondsSince1970 : Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds : Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

enum Constant {
    
    
    static let missionStatement = "We hope Bump can foster inclusive yet private communities where Grinnellians can find meaningful connections."
    
    static let howToUseStatement = "1. Join your Groupchats.\n2. 🤠 Starts Chat = Recieve an initial alert. \n3. Follow Chat = Recieve all message alerts.\n** All Chats last for one day."
    
    static let oBlueLight = UIColor(red:0.10, green:0.68, blue:0.96, alpha:1.0)
    static let oBlue = UIColor(red:0.00, green:0.65, blue:1.00, alpha:1.0)
    
    
    static let oGray = UIColor(red:0.905, green:0.91, blue:0.925, alpha:1.0)
    static let oGrayLight = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0)
    
    static let oBlack = UIColor(red:0.08, green:0.09, blue:0.10, alpha:1.0)
    
    static let textfieldPlaceholderGray = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
    
    
    
    
    static let bottomPopUpAttributes : EKAttributes = {
        var attributes = EKAttributes.bottomFloat
        attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.none
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(UIColor.white), EKColor(UIColor.white)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.5)))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 18.0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.statusBar = .light
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.15))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 10), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .constant(value: UIScreen.main.bounds.height))
        
        return attributes
    }()
    
    static let centerPopUpAttributes : EKAttributes = {
        var attributes = EKAttributes.centerFloat
        attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.none
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(UIColor.white), EKColor(UIColor.white)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.5)))
        //attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 18.0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.statusBar = .light
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.15))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 10), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .constant(value: UIScreen.main.bounds.height))
        
        return attributes
    }()
    
    static func fixedPopUpAttributes(heightWidthRatio : CGFloat) -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(UIColor.white), EKColor(UIColor.white)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.5)))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 18.0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.statusBar = .light

        attributes.exitAnimation = .init(translate: .init(duration: 0.15))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 10), height: .constant(value: UIScreen.main.bounds.width * heightWidthRatio))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .constant(value: UIScreen.main.bounds.height))

        return attributes
    }
}




extension UIScrollView {
    func scrollToTop(_ animated: Bool) {
        var topContentOffset: CGPoint
        topContentOffset = CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top)
        setContentOffset(topContentOffset, animated: animated)
    }
}


extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}






extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}









class TextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
