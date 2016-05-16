//
//  SecondViewController.swift
//  SwiftyNotificationCenterExample
//
//  Created by Jon Shier on 5/15/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import SwiftyNotificationCenter
import UIKit

class SecondViewController: UIViewController {
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SNC.observeKeyboardDidShowNotification(withObserver: self).onNotification { 
            print("Received onNotification")
        }
        .withNotification { (notification: KeyboardNotification) in
            print(notification)
        }
    }
}
