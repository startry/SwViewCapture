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
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 2)
        
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
        
        // Scroll To Bottom show all cached view
        if self.frame.size.height < self.contentSize.height {
            self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height)
            
            self.swRenderImageView({ [weak self] (capturedImage) -> Void in
                
                let strongSelf = self!
                // Recover View
                strongSelf.removeFromSuperview()
                strongSelf.frame = bakFrame
                strongSelf.contentOffset = bakOffset
                bakSuperView?.addSubview(strongSelf)
                
                snapShotView.removeFromSuperview()
                
                strongSelf.isCapturing = false
                
                completionHandler(capturedImage: capturedImage)
            })
        }else{
            self.swRenderImageView({ [weak self] (capturedImage) -> Void in
                // Recover View
                let strongSelf = self!
                
                strongSelf.removeFromSuperview()
                strongSelf.frame = bakFrame
                strongSelf.contentOffset = bakOffset
                bakSuperView?.addSubview(strongSelf)
                
                snapShotView.removeFromSuperview()
                
                strongSelf.isCapturing = false
                
                completionHandler(capturedImage: capturedImage)
            })
        }
       
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
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 2)
        
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

public extension WKWebView {
    
    public func swContentCapture(completionHandler:(capturedImage: UIImage?) -> Void) {
        
        self.isCapturing = true
        
        // WKWebview's WKContentView will only render visible view, and cache a little more. 
        // It's useless to render all view by change frame according to content.
        if(self.scrollView.contentSize.height >= UIScreen.mainScreen().bounds.height * 2){
            self.swContentCompCapture(completionHandler)
            return
        }
        
        // Put a fake Cover of View
        let snapShotView = self.snapshotViewAfterScreenUpdates(true)
        snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        
        // Backup
        let bakOffset = self.scrollView.contentOffset
        let bakFrame = self.frame
        
        self.frame = CGRectMake(bakFrame.origin.x, bakFrame.origin.y, self.scrollView.contentSize.width, self.scrollView.contentSize.height)
        self.scrollView.contentOffset = CGPointZero
        
        let method: Method = class_getInstanceMethod(object_getClass(self), Selector("setFrame:"))
        let swizzledMethod: Method = class_getInstanceMethod(object_getClass(self), Selector("swSetFrame:"))
        method_exchangeImplementations(method, swizzledMethod)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            let bounds = self.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 2)
            
            if (self.swContainsWKWebView()) {
                self.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
            }else{
                self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            }
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.frame = bakFrame
            self.scrollView.contentOffset = bakOffset
            
            snapShotView.removeFromSuperview()
        
            method_exchangeImplementations(swizzledMethod, method)
        
            self.isCapturing = false
            
            completionHandler(capturedImage: capturedImage)
        }
    }
    
    // BUG: Exists a problem, absolute property.
    public func swContentCompCapture (completionHandler: (capturedImage: UIImage?) -> Void) {
        // Put a fake Cover of View
        let snapShotView = self.snapshotViewAfterScreenUpdates(true)
        snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        
        // Backup
        let bakOffset    = self.scrollView.contentOffset

        // Divide
        let page  = floorf(Float(self.scrollView.contentSize.height / self.bounds.height))
        
        UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, false, 2)
        
        self.swContentDraw(0, maxIndex: Int(page), drawCallback: { [weak self] () -> Void in
            let strongSelf = self
            
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            // Recover
            strongSelf?.scrollView.setContentOffset(bakOffset, animated: false)
            snapShotView.removeFromSuperview()
            
            strongSelf?.isCapturing = false
            
            completionHandler(capturedImage: capturedImage)
        })

    }
    
    public func swContentDraw (index: Int, maxIndex: Int, drawCallback: () -> Void) {
        
        self.scrollView.setContentOffset(CGPointMake(0, CGFloat(index) * self.scrollView.frame.size.height), animated: false)
        let splitFrame = CGRectMake(0, CGFloat(index) * self.scrollView.frame.size.height, bounds.size.width, bounds.size.height)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.drawViewHierarchyInRect(splitFrame, afterScreenUpdates: true)
            
            if index < maxIndex {
                self.swContentDraw(index + 1, maxIndex: maxIndex, drawCallback: drawCallback)
            }else{
                drawCallback()
            }
        }
    }
    
}
