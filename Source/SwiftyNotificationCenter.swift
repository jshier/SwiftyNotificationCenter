//
//  SwiftyNotificationCenter.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 10/31/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import Foundation

public typealias KeyboardNotificationHandler = (keyboardNotification: KeyboardNotification) -> Void

public struct SwiftyNotificationCenter {
    private static let sharedObserver = NotificationCenterObserver()
    
    public static func addKeyboardWillShowObserver(handler: KeyboardNotificationHandler) {
        sharedObserver.addKeyboardWillShowObserver(handler)
    }
    
    class NotificationCenterObserver : NSObject {
        private let notificationCenter = NSNotificationCenter.defaultCenter()
        private var keyboardWillShowHandler: KeyboardNotificationHandler?
        
        func addKeyboardWillShowObserver(handler: KeyboardNotificationHandler) {
            if let existing = keyboardWillShowHandler {
                keyboardWillShowHandler = { keyboardNotification in
                    existing(keyboardNotification: keyboardNotification)
                    handler(keyboardNotification: keyboardNotification)
                }
            }
            else {
                keyboardWillShowHandler = handler
            }
            notificationCenter.addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        }
        
        func keyboardWillShowNotification(notification: NSNotification) {
            let keyboardNotification = KeyboardNotification(notification: notification)
            keyboardWillShowHandler?(keyboardNotification: keyboardNotification)
        }
    }
    
}

public struct KeyboardNotification {
    let animationCurve: UIViewAnimationOptions
    let animationDuration: NSTimeInterval
    let frameBegin: CGRect
    let frameEnd: CGRect
    
    private let userInfo: [NSObject : AnyObject]
    
    init(notification: NSNotification) {
        userInfo = notification.userInfo!
        
        let rawAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntegerValue
        animationCurve = UIViewAnimationOptions(rawValue: rawAnimationCurve)
        animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    }
    
    @available(iOS 9.0, *)
    var isLocal: Bool {
        return (userInfo[UIKeyboardIsLocalUserInfoKey] as! NSNumber).boolValue
    }
}