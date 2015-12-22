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
    
    public static func addKeyboardWillShowObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardWillShowObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardWillShowObserver<O : Hashable>(observer: O) {
        sharedKeyboardObserver.removeKeyboardWillShowObserver(observer)
    }
    
    public static func addKeyboardDidShowObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardDidShowObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardDidShowObserver<O : Hashable>(observer: O) {
        sharedKeyboardObserver.removeKeyboardDidShowObserver(observer)
    }
    
    public static func addKeyboardWillHideObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardWillHideObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardWillHideObserver<O : Hashable>(observer: O) {
        sharedKeyboardObserver.removeKeyboardWillHideObserver(observer)
    }
    
    public static func addKeyboardDidHideObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardDidHideObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardDidHideObserver<O : Hashable>(observer: O) {
        sharedKeyboardObserver.removeKeyboardDidHideObserver(observer)
    }
    
    public static func addKeyboardWillChangeFrameObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardWillChangeFrameObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardWillChangeFrameObserver<O : Hashable>(observer: O) {
        sharedKeyboardObserver.removeKeyboardWillChangeFrameObserver(observer)
    }
    
    public static func addKeyboardDidChangeFrameObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        sharedKeyboardObserver.addKeyboardDidChangeFrameObserver(observer, handler: handler)
    }
    
    public static func removeKeyboardDidChangeFrameObserver<O : Hashable>(observer: O) {
        sharedKeyboardObserver.removeKeyboardDidChangeFrameObserver(observer)
    }
    
    public static func removeKeyboardObserver<O : Hashable>(observer: O) {
        sharedKeyboardObserver.removeKeyboardObserver(observer)
    }
}

public typealias KeyboardNotificationHandler = (notification: KeyboardNotification) -> Void

class KeyboardObserver : NotificationObserver {
    
    func addKeyboardWillShowObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardWillShowNotification, handler: convertHandler(handler))
    }
    
    func addKeyboardDidShowObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardDidShowNotification, handler: convertHandler(handler))
    }
    
    func addKeyboardWillHideObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardWillHideNotification, handler: convertHandler(handler))
    }
    
    func addKeyboardDidHideObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardDidHideNotification, handler: convertHandler(handler))
    }
    
    func addKeyboardWillChangeFrameObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardWillChangeFrameNotification, handler: convertHandler(handler))
    }
    
    func addKeyboardDidChangeFrameObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(observer, withKey: UIKeyboardDidChangeFrameNotification, handler: convertHandler(handler))
    }
    
    func removeKeyboardWillShowObserver<O : Hashable>(observer: O) {
        removeObserver(observer, forKey: UIKeyboardWillShowNotification)
    }
    
    func removeKeyboardDidShowObserver<O : Hashable>(observer: O) {
        removeObserver(observer, forKey: UIKeyboardDidShowNotification)
    }
    
    func removeKeyboardWillHideObserver<O : Hashable>(observer: O) {
        removeObserver(observer, forKey: UIKeyboardWillHideNotification)
    }
    
    func removeKeyboardDidHideObserver<O : Hashable>(observer: O) {
        removeObserver(observer, forKey: UIKeyboardDidHideNotification)
    }
    
    func removeKeyboardWillChangeFrameObserver<O : Hashable>(observer: O) {
        removeObserver(observer, forKey: UIKeyboardWillChangeFrameNotification)
    }
    
    func removeKeyboardDidChangeFrameObserver<O : Hashable>(observer: O) {
        removeObserver(observer, forKey: UIKeyboardDidChangeFrameNotification)
    }
    
    func removeKeyboardObserver<O : Hashable>(observer: O) {
        removeObserver(observer)
    }
    
    @objc override func handleNotification(notification: NSNotification) {
        let keyboardNotification = KeyboardNotification(notification: notification)
        notifyObservers(ofName: notification.name, withNotification: keyboardNotification)
    }
}

public struct KeyboardNotification : Notification {
    public let animationOptions: UIViewAnimationOptions
    public let animationDuration: NSTimeInterval
    public let frameBegin: CGRect
    public let frameEnd: CGRect
    
    private let userInfo: [NSObject : AnyObject]
    
    init(notification: NSNotification) {
        userInfo = notification.userInfo!
        
        let rawAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntegerValue
        animationOptions = UIViewAnimationOptions(rawValue: rawAnimationCurve)
        animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    }
    
    @available(iOS 9.0, *)
    public var isLocal: Bool {
        return (userInfo[UIKeyboardIsLocalUserInfoKey] as! NSNumber).boolValue
    }
}
