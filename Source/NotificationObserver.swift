//
//  NotificationObserver.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 11/26/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import Foundation

protocol Notification {
    init(notification: NSNotification)
}

typealias NotificationHandler = (notification: Notification) -> Void

class NotificationObserver {
    private let lock = Lock()
    private let center = NSNotificationCenter.defaultCenter()
    
    private var notificationHandlers: [String : [Int : NotificationHandler]] = [:]
    private var isObserving: [String : Bool] = [:]
    
    private let notificationSelector = Selector("handleNotification:")
    
    func addObserver<O : Hashable>(observer: O, withKey key: String, handler: NotificationHandler) {
        lock.around {
            if var observers = notificationHandlers[key] {
                observers[observer.hashValue] = handler
                notificationHandlers[key] = observers
            }
            else {
                notificationHandlers[key] = [observer.hashValue : handler]
            }
            
            if !(isObserving[key] ?? false) {
                center.addObserver(self, selector: notificationSelector, name: key, object: nil)
                isObserving[key] = true
            }
        }
    }
    
    func removeObserver<O : Hashable>(observer: O, forKey key: String) {
        lock.around {
            notificationHandlers[key]?.removeValueForKey(observer.hashValue)
            
            if notificationHandlers[key]?.values.count == 0 {
                center.removeObserver(self, name: key, object: nil)
                isObserving[key] = false
            }
        }
    }
    
    func removeObserver<O : Hashable>(observer: O) {
        lock.around {
            notificationHandlers.keys.forEach { notificationHandlers[$0]!.removeValueForKey(observer.hashValue) }
        }
    }
    
    func convertHandler<T : Notification>(handler: T -> Void) -> NotificationHandler {
        return { notification in
            if let typedNotification = notification as? T {
                handler(typedNotification)
            }
        }
    }
    
    func notifyObservers(ofName name: String, withNotification notification: Notification) {
        notificationHandlers[name]?.values.forEach { $0(notification: notification) }
    }
    
    @objc func handleNotification(notification: NSNotification) {
        fatalError("NotificationObserver subclasses must override handleNotification(notification: NSNotification)")
    }
}
