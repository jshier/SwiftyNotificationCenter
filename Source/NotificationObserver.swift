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

class NotificationObserver<NotificationType: Notification> {
    typealias Handler = (notification: NotificationType) -> Void
    
    private let lock = Lock()
    private let center = NSNotificationCenter.defaultCenter()
    
    private var notificationHandlers: [String : [NotificationHandler<NotificationType>]] = [:]
    private var isSubscribedTo: [String : Bool] = [:]
    
    private let notificationSelector = Selector("handleNotification:")
    
    func addObserver(observer: AnyObject, withKey key: String, handler: Handler) {
        lock.around {
            if var observers = notificationHandlers[key] {
                observers = observers.filter { $0.observer != nil }
                if let index = observers.indexOf({ $0.observer === observer }) {
                    observers[index] = NotificationHandler<NotificationType>(observer: observer, handler: handler)
                }
                else {
                    observers.append(NotificationHandler<NotificationType>(observer: observer, handler: handler))
                }
                notificationHandlers[key] = observers
            }
            else {
                notificationHandlers[key] = [NotificationHandler<NotificationType>(observer: observer, handler: handler)]
            }
            
            if let isSubscribed = isSubscribedTo[key] {
                if !isSubscribed {
                    center.addObserver(self, selector: notificationSelector, name: key, object: nil)
                    isSubscribedTo[key] = true
                }
            }
            else {
                center.addObserver(self, selector: notificationSelector, name: key, object: nil)
                isSubscribedTo[key] = true
            }
        }
    }
    
    func removeObserver(observer: AnyObject, forKey key: String) {
        guard var observers = notificationHandlers[key] else { return }
        
        lock.around {
            observers = observers.filter { $0.observer != nil }
            if let index = observers.indexOf({ $0.observer === observer }) {
                observers.removeAtIndex(index)
            }
            
            if observers.count == 0 {
                isSubscribedTo[key] = false
                center.removeObserver(self, name: key, object: nil)
            }
        }
    }
    
    func removeObserver(observer: AnyObject) {
        notificationHandlers.keys.forEach { removeObserver(observer, forKey: $0) }
    }
    
    func notifyObservers(ofKey key: String, withNotification notification: Notification) {
        guard var observers = notificationHandlers[key] else { return }
        observers = observers.filter { $0.observer != nil }
        observers.forEach { $0.handler(notification: notification as! NotificationType) }
        notificationHandlers[key] = observers
    }
    
    @objc func handleNotification(notification: NSNotification) {
        fatalError("NotificationObserver subclasses must override handleNotification(notification: NSNotification)")
    }
}

struct NotificationHandler<NotificationType: Notification> {
    typealias Handler = (notification: NotificationType) -> Void
    
    weak var observer: AnyObject?
    let handler: Handler
}
