//
//  KeyboardObserver.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 11/7/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import Foundation

extension SwiftyNotificationCenter {
    private static let sharedKeyboardObserver = KeyboardObserver()
    
    public static func addKeyboardWillShowObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardWillShowObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardWillShowObserver(observer: AnyObject) {
        sharedKeyboardObserver.removeKeyboardWillShowObserver(observer)
    }
    
    public static func addKeyboardDidShowObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardDidShowObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardDidShowObserver(observer: AnyObject) {
        sharedKeyboardObserver.removeKeyboardDidShowObserver(observer)
    }
    
    public static func addKeyboardWillHideObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardWillHideObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardWillHideObserver(observer: AnyObject) {
        sharedKeyboardObserver.removeKeyboardWillHideObserver(observer)
    }
    
    public static func addKeyboardDidHideObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardDidHideObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardDidHideObserver(observer: AnyObject) {
        sharedKeyboardObserver.removeKeyboardDidHideObserver(observer)
    }
    
    public static func addKeyboardWillChangeFrameObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardWillChangeFrameObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardWillChangeFrameObserver(observer: AnyObject) {
        sharedKeyboardObserver.removeKeyboardWillChangeFrameObserver(observer)
    }
    
    public static func addKeyboardDidChangeFrameObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardDidChangeFrameObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardDidChangeFrameObserver(observer: AnyObject) {
        sharedKeyboardObserver.removeKeyboardDidChangeFrameObserver(observer)
    }
    
    public static func removeKeyboardObserver(observer: AnyObject) {
        sharedKeyboardObserver.removeKeyboardObserver(observer)
    }
}

public typealias KeyboardNotificationHandler = (notification: KeyboardNotification) -> Void

class KeyboardObserver : NotificationObserver<KeyboardNotification> {
    
    func addKeyboardWillShowObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardWillShowNotification, handler: handler)
    }
    
    func addKeyboardDidShowObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardDidShowNotification, handler: handler)
    }
    
    func addKeyboardWillHideObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardWillHideNotification, handler: handler)
    }
    
    func addKeyboardDidHideObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardDidHideNotification, handler: handler)
    }
    
    func addKeyboardWillChangeFrameObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardWillChangeFrameNotification, handler: handler)
    }
    
    func addKeyboardDidChangeFrameObserver(observer: AnyObject, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardDidChangeFrameNotification, handler: handler)
    }
    
    func removeKeyboardWillShowObserver(observer: AnyObject) {
        removeObserver(observer, forKey: UIKeyboardWillShowNotification)
    }
    
    func removeKeyboardDidShowObserver(observer: AnyObject) {
        removeObserver(observer, forKey: UIKeyboardDidShowNotification)
    }
    
    func removeKeyboardWillHideObserver(observer: AnyObject) {
        removeObserver(observer, forKey: UIKeyboardWillHideNotification)
    }
    
    func removeKeyboardDidHideObserver(observer: AnyObject) {
        removeObserver(observer, forKey: UIKeyboardDidHideNotification)
    }
    
    func removeKeyboardWillChangeFrameObserver(observer: AnyObject) {
        removeObserver(observer, forKey: UIKeyboardWillChangeFrameNotification)
    }
    
    func removeKeyboardDidChangeFrameObserver(observer: AnyObject) {
        removeObserver(observer, forKey: UIKeyboardDidChangeFrameNotification)
    }
    
    func removeKeyboardObserver(observer: AnyObject) {
        removeObserver(observer)
    }
    
    @objc override func handleNotification(notification: NSNotification) {
        let keyboardNotification = KeyboardNotification(notification: notification)
        notifyObservers(ofKey: notification.name, withNotification: keyboardNotification)
    }
}

public struct KeyboardNotification : Notification {
    public let animationOptions: UIViewAnimationOptions
    public let animationDuration: NSTimeInterval
    public let frameBegin: CGRect
    public let frameEnd: CGRect
    public let isLocal: Bool
    
    private let userInfo: [NSObject : AnyObject]
    
    init(notification: NSNotification) {
        userInfo = notification.userInfo!
        
        let rawAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntegerValue
        animationOptions = UIViewAnimationOptions(rawValue: rawAnimationCurve)
        animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        isLocal = (userInfo[UIKeyboardIsLocalUserInfoKey] as! NSNumber).boolValue
    }
}
