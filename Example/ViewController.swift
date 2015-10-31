//
//  ViewController.swift
//  SwiftyNotificationCenterExample
//
//  Created by Jon Shier on 10/31/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import SwiftyNotificationCenter
import UIKit

class ViewController: UIViewController, KeyboardObserver {
    override func viewDidLoad() {
        startObservingKeyboard()
    }
    
    let keyboardWillShow: KeyboardNotificationHandler = { keyboardNotification in
        print(keyboardNotification)
    }
}

protocol KeyboardObserver {
    var keyboardWillShow: KeyboardNotificationHandler { get }
}

extension KeyboardObserver {
    func startObservingKeyboard() {
        SwiftyNotificationCenter.addKeyboardWillShowObserver(keyboardWillShow)
    }
}