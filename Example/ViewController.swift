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
//        SNC.addKeyboardWillShowObserver(self, handler: keyboardWillShowHandler)
//        SNC.addKeyboardDidShowObserver(self, handler: keyboardDidShowHandler)
//        SNC.addKeyboardWillHideObserver(self, handler: keyboardWillHideHandler)
//        SNC.addKeyboardDidHideObserver(self, handler: keyboardDidHideHandler)
//        SNC.addKeyboardWillChangeFrameObserver(self, handler: keyboardWillChangeFrameHandler)
//        SNC.addKeyboardDidChangeFrameObserver(self, handler: keyboardDidChangeFrameHandler)
//        keyboardDidShowNotification.onNotification { 
//            print("Received onNotification")
//        }
//        .withNotification { (notification: KeyboardNotification) in
//            print("Received specific notification: \(notification)")
//        }
//        .withNotification(keyboardDidShowHandler)
        observeKeyboardDidShowNotification()
    }
    
    @IBAction func endEditing(sender: UIButton) {
        view.endEditing(true)
    }
    
    func keyboardWillShowHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
//        print("*** Removing willShow observer. ***")
//        SNC.removeKeyboardWillShowObserver(self)
    }
    
    func keyboardDidShowHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
//        print("*** Removing didShow observer. ***")
//        SNC.removeKeyboardDidShowObserver(self)
    }
    
    func keyboardWillHideHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
//        print("*** Removing willHide observer. ***")
//        SNC.removeKeyboardWillHideObserver(self)
    }
    
    func keyboardDidHideHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
//        print("*** Removing didHide observer. ***")
//        SNC.removeKeyboardDidHideObserver(self)
    }
    
    func keyboardWillChangeFrameHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
//        print("*** Removing willChangeFrame observer. ***")
//        SNC.removeKeyboardWillChangeFrameObserver(self)
    }
    
    func keyboardDidChangeFrameHandler(keyboardNotification: KeyboardNotification) {
        print(keyboardNotification)
//        print("*** Removing didChangeFrame observer. ***")
//        SNC.removeKeyboardDidChangeFrameObserver(self)
    }
}

extension ViewController: KeyboardDidShowObserving {
    func keyboardDidShow(notification: KeyboardNotification) {
        print(notification)
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