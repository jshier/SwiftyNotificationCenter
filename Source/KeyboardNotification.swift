//
//  KeyboardNotification.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 11/7/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import Foundation

public struct KeyboardNotification : Notification, NotificationConvertible {
    public let animationOptions: UIViewAnimationOptions
    public let animationDuration: NSTimeInterval
    public let frameBegin: CGRect
    public let frameEnd: CGRect
    public let isLocal: Bool
    
    private let userInfo: [NSObject : AnyObject]
    
    public init(notification: NSNotification) {
        userInfo = notification.userInfo!
        
        let rawAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntegerValue
        animationOptions = UIViewAnimationOptions(rawValue: rawAnimationCurve)
        animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        isLocal = (userInfo[UIKeyboardIsLocalUserInfoKey] as! NSNumber).boolValue
    }
}
