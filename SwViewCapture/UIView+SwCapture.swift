//
//  UIView+SwCapture.swift
//  SwViewCapture
//
//  Created by chenxing.cx on 16/2/17.
//  Copyright © 2016年 Startry. All rights reserved.
//

import UIKit
import WebKit
import ObjectiveC

private var SwViewCaptureKey_IsCapturing: String = "SwViewCapture_AssoKey_isCapturing"

public extension UIView {
    
    func swSetFrame(frame: CGRect) {
        // Do nothing, use for swizzling
    }
    
    var isCapturing:Bool! {
        get {
            let num =  objc_getAssociatedObject(self, &SwViewCaptureKey_IsCapturing)
            if num == nil {
                return false
            }
            return num.boolValue
        }
        set(newValue) {
            let num = NSNumber(bool: newValue)
            objc_setAssociatedObject(self, &SwViewCaptureKey_IsCapturing, num, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Ref: chromium source - snapshot_manager, fix wkwebview screenshot bug.
    // https://chromium.googlesource.com/chromium/src.git/+/46.0.2478.0/ios/chrome/browser/snapshots/snapshot_manager.mm
    public func swContainsWKWebView() -> Bool {
        if self.isKindOfClass(WKWebView) {
            return true
        }
        for subView in self.subviews {
            if (subView.swContainsWKWebView()) {
                return true
            }
        }
        return false
    }
    
    public func swCapture(completionHandler: (capturedImage: UIImage?) -> Void) {
        
        self.isCapturing = true
        
        let bounds = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, -self.frame.origin.x, -self.frame.origin.y);
        
        if (swContainsWKWebView()) {
            self.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        }else{
            self.layer.renderInContext(context!)
        }
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        CGContextRestoreGState(context);
        UIGraphicsEndImageContext()
        
        self.isCapturing = false
        
        completionHandler(capturedImage: capturedImage)
    }
}

