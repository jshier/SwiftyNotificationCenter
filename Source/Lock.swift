//
//  Lock.swift
//  SwiftyNotificationCenter
//
//  Created by Jon Shier on 11/7/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import Darwin

class Lock {
    private var lock = OS_SPINLOCK_INIT
    
    func around(@noescape closure: () -> ()) {
        OSSpinLockLock(&lock)
        closure()
        OSSpinLockUnlock(&lock)
    }
    
    func around<T>(@noescape closure: () -> T) -> T {
        OSSpinLockLock(&lock)
        let value = closure()
        OSSpinLockUnlock(&lock)
        return value
    }
}
