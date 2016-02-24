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

public extension UIScrollView {
    
    public func swContentCapture (completionHandler: (capturedImage: UIImage?) -> Void) {
        
        self.isCapturing = true
        
        // Put a fake Cover of View
        let snapShotView = self.snapshotViewAfterScreenUpdates(false)
        snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        
        // Backup all properties of scrollview if needed
        let bakFrame     = self.frame
        let bakOffset    = self.contentOffset
        let bakSuperView = self.superview
        let bakIndex     = self.superview?.subviews.indexOf(self)
        
        // Scroll To Bottom show all cached view
        if self.frame.size.height < self.contentSize.height {
            self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height)
        }
        
        self.swRenderImageView({ [weak self] (capturedImage) -> Void in
            // Recover View
            
            let strongSelf = self!
            
            strongSelf.removeFromSuperview()
            strongSelf.frame = bakFrame
            strongSelf.contentOffset = bakOffset
            bakSuperView?.insertSubview(strongSelf, atIndex: bakIndex!)
            
            snapShotView.removeFromSuperview()
            
            strongSelf.isCapturing = false
            
            completionHandler(capturedImage: capturedImage)
        })
       
    }
    
    private func swRenderImageView(completionHandler: (capturedImage: UIImage?) -> Void) {
        // Rebuild scrollView superView and their hold relationship
        let swTempRenderView = UIView(frame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height))
        self.removeFromSuperview()
        swTempRenderView.addSubview(self)
        
        self.contentOffset = CGPointZero
        self.frame         = swTempRenderView.bounds
        
        // Swizzling setFrame
        let method: Method = class_getInstanceMethod(object_getClass(self), Selector("setFrame:"))
        let swizzledMethod: Method = class_getInstanceMethod(object_getClass(self), Selector("swSetFrame:"))
        method_exchangeImplementations(method, swizzledMethod)
        
        let bounds = self.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        if (swContainsWKWebView()) {
            self.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        }else{
            self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        }
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        method_exchangeImplementations(swizzledMethod, method)
        
        completionHandler(capturedImage: capturedImage)
    }
}

public extension UIWebView {
    
    public func swContentCapture (completionHandler: (capturedImage: UIImage?) -> Void) {
        self.scrollView.swContentCapture(completionHandler)
    }
}
