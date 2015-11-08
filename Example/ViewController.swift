//
//  ViewController.swift
//  SwiftyNotificationCenterExample
//
//  Created by Jon Shier on 10/31/15.
//  Copyright © 2015 Jon Shier. All rights reserved.
//

import SwiftyNotificationCenter
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        SwiftyNotificationCenter.addKeyboardWillShowObserver(self, handler: keyboardWillShowHandler)
        SNC.addKeyboardDidShowObserver(self, handler: keyboardDidShowHandler)
    }
    
    func keyboardWillShowHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
        print("*** Removing willShow observer. ***")
        SwiftyNotificationCenter.removeKeyboardWillShowObserver(self)
    }
    
    func keyboardDidShowHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
        print("*** Removing didShow observer. ***")
        SwiftyNotificationCenter.removeKeyboardDidShowObserver(self)
    }
}

extension UIViewAnimationOptions : CustomStringConvertible {
    public var description: String {
        let propertyDescriptions = ["LayoutSubviews", "AllowUserInteraction", "BeginFromCurrentState", "Repeat", "Autoreverse", "OverrideInheritedDuration", "OverrideInheritedCurve", "AllowAnimatedContent", "ShowHideTransitionViews", "OverrideInheritedOptions"]
        var properties = [String]()
        for (index, description) in propertyDescriptions.enumerate() where contains(UIViewAnimationOptions(rawValue: UInt(1 << index))) {
            properties.append(description)
        }
        
        let curveDescriptions = ["CurveEaseInOut", "CurveEaseIn", "CurveEaseOut", "CurveLinear"]
        var curves = [String]()
        for (index, description) in curveDescriptions.enumerate() where contains(UIViewAnimationOptions(rawValue: UInt(index << 16))) {
            curves.append(description)
        }
        
        let transitionDescriptions = ["TransitionNone", "TransitionFlipFromLeft", "TransitionFlipFromRight", "TransitionCurlUp", "TransitionCurlDown", "TransitionCrossDissolve", "TransitionFlipFromTop", "TransitionFlipFromBottom"]
        var transitions = [String]()
        for (index, description) in transitionDescriptions.enumerate() where contains(UIViewAnimationOptions(rawValue: UInt(index << 20))) {
            transitions.append(description)
        }
        
        return "UIViewAnimationOptions:\n\tProperties: \(properties.description)\n\tCurves: \(curves.description)\n\tTransitions: \(transitions.description)"
    }
}