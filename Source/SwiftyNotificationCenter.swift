//
//  SwiftyNotificationCenter.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 10/31/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

public typealias SNC = SwiftyNotificationCenter

public class SwiftyNotificationCenter {
    private static let notificationCenter = NSNotificationCenter.defaultCenter()
    private static let sharedManager = ObservatoryManager()
    
    static func addObserver(observer: AnyObject, forKey key: NotificationNameConvertible, withSelector selector: Selector) {
        notificationCenter.addObserver(observer, selector: selector, name: key.notificationName, object: nil)
    }
    
    static func removeObserver(observer: AnyObject, forKey key: NotificationNameConvertible? = nil) {
        guard let key = key else {
            notificationCenter.removeObserver(observer)
            return
        }
        
        notificationCenter.removeObserver(observer, name: key.notificationName, object: nil)
    }
    
    public static func observeNotification(notification: NotificationNameConvertible, withObserver observer: AnyObject) -> Observatory {
        return sharedManager.observeNotification(notification, withObserver: observer)
    }
    
    public static func observeKeyboardDidShowNotification(withObserver observer: AnyObject) -> Observatory {
        return observeNotification(UIKeyboardDidShowNotification, withObserver: observer)
    }
}

public protocol NotificationNameConvertible {
    var notificationName: String { get }
}

public extension NotificationNameConvertible where Self: RawRepresentable, Self.RawValue == String {
    var notificationName: String { return rawValue }
}

extension String: NotificationNameConvertible {
    public var notificationName: String { return self }
}

public class ObservatoryManager {
    private var observatories: [String: [Observatory]] = [:]
    
    func observeNotification(notification: NotificationNameConvertible, withObserver observer: AnyObject) -> Observatory {
        let observatory = Observatory(notificationName: notification, observer: observer)
        if let notificationObservatories = observatories[notification.notificationName] {
            var notificationObservatories = notificationObservatories
            notificationObservatories.append(observatory)
            observatories[notification.notificationName] = notificationObservatories
        }
        else {
            observatories[notification.notificationName] = [observatory]
            SNC.addObserver(self, forKey: notification, withSelector: #selector(handleNotification(_:)))
        }
        
        return observatory
    }
    
    @objc func handleNotification(notification: NSNotification) {
        guard let notificationObservatories = observatories[notification.name] else { fatalError("Attempted to handle a notification with no observatories.") }
        
        let observatoriesWithObservers = notificationObservatories.filter({ $0.observer != nil })
        
        guard observatoriesWithObservers.count > 0 else {
            observatories[notification.name] = nil
            SNC.removeObserver(self, forKey: notification.name)
            return
        }

        observatoriesWithObservers.forEach { $0.handleNotification(notification) }
    }
}

public class Observatory {
    typealias NotificationHandler = (notification: NSNotification) -> Void
    
    private var handlers: [NotificationHandler] = []
    private let notificationName: NotificationNameConvertible
    weak var observer: AnyObject?
    
    init(notificationName: NotificationNameConvertible, observer: AnyObject) {
        self.notificationName = notificationName
        self.observer = observer
    }
    
    public func onNotification(notificationHandler: () -> Void) -> Self {
        handlers.append({ _ in notificationHandler() })
        
        return self
    }
    
    public func withNotification<T: NotificationConvertible>(notificationHandler: (notification: T) -> Void) -> Self {
        handlers.append({ notification in notificationHandler(notification: T(notification: notification)) })
        
        return self
    }
    
    func handleNotification(notification: NSNotification) {
        handlers.forEach { $0(notification: notification) }
    }
}

extension Observatory {
    func withKeyboardNotification(notificationHandler: (notification: KeyboardNotification) -> Void) -> Self {
        return withNotification(notificationHandler)
    }
}

public protocol NotificationConvertible {
    init(notification: NSNotification)
}

public protocol KeyboardDidShowObserving {
    func keyboardDidShow(notification: KeyboardNotification)
}

public extension KeyboardDidShowObserving where Self: UIViewController {
    func observeKeyboardDidShowNotification() {
        SNC.observeKeyboardDidShowNotification(withObserver: self).withKeyboardNotification(keyboardDidShow)
    }
}
