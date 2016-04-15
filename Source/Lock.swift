//
//  Lock.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 11/7/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import Darwin

final class Lock {
    
    private var queue: dispatch_queue_t
    
    init(label: String = String(format: "com.jonshier.SwiftyNotificationCenter.LockQueue.%08x%08x", arc4random(), arc4random())) {
        queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL)
    }
    
    func around(closure: () -> Void) {
        dispatch_sync(queue, closure)
    }
    
    func around<T>(closure: () -> T) -> T {
        var out: T?
        dispatch_sync(queue) { out = closure() }
        return out!
    }
    
}
