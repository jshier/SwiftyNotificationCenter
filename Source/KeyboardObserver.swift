//
//  KeyboardObserver.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 11/7/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import Foundation

public typealias KeyboardNotificationHandler = (keyboardNotification: KeyboardNotification) -> Void

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
}

class KeyboardObserver : NSObject {
    private let lock = Lock()
    private let sharedCenter = NSNotificationCenter.defaultCenter()
    
    private var observerHandlers: [String : [Int : KeyboardNotificationHandler]] = [:]
    private var isObserving: [String : Bool] = [:]
    
    func addKeyboardWillShowObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(withKey: UIKeyboardWillShowNotification, observer: observer, handler: handler)
    }
    
    func addKeyboardDidShowObserver<O : Hashable>(observer: O, handler: KeyboardNotificationHandler) {
        addObserver(withKey: UIKeyboardDidShowNotification, observer: observer, handler: handler)
    }
    
    func removeKeyboardWillShowObserver<O : Hashable>(observer: O) {
        removeObserver(forKey: UIKeyboardWillShowNotification, observer: observer)
    }
    
    func removeKeyboardDidShowObserver<O : Hashable>(observer: O) {
        removeObserver(forKey: UIKeyboardDidShowNotification, observer: observer)
    }
    
    func addObserver<O : Hashable>(withKey key: String, observer: O, handler: KeyboardNotificationHandler) {
        if var observers = observerHandlers[key] {
            observers[observer.hashValue] = handler
            observerHandlers[key] = observers
        }
        else {
            observerHandlers[key] = [observer.hashValue : handler]
        }
        
        if !(isObserving[key] ?? false) {
            sharedCenter.addObserver(self, selector: "handleKeyboardNotification:", name: key, object: nil)
            isObserving[key] = true
        }
    }
    
    func removeObserver<O : Hashable>(forKey key: String, observer: O) {
        observerHandlers[key]?[observer.hashValue] = nil
        
        if observerHandlers[key]?.values.count == 0 {
            sharedCenter.removeObserver(self, name: key, object: nil)
            isObserving[key] = false
        }
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        let keyboardNotification = KeyboardNotification(notification: notification)
        observerHandlers[notification.name]?.values.forEach { $0(keyboardNotification: keyboardNotification) }
    }
}

public struct KeyboardNotification {
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
