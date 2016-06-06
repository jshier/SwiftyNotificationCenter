//
//  NSNotificationCenterExtensions.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 6/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import Foundation

/// Convenience functions for `NSNotificationCenter`, likely obsoleted with Swift 3.
extension NSNotificationCenter {
    public func addObserver(observer: AnyObject, forName name: String? = nil, usingSelector selector: Selector, object: AnyObject? = nil) {
        addObserver(observer, selector: selector, name: name, object: object)
    }
    
    public func removeObserver(observer: AnyObject, forName name: String? = nil, object: AnyObject? = nil) {
        removeObserver(observer, name: name, object: object)
    }
    
    public func postNotification(forName name: String, withUserInfo userInfo: [NSObject : AnyObject]? = nil, object: AnyObject? = nil) {
        postNotificationName(name, object: object, userInfo: userInfo)
    }
}
