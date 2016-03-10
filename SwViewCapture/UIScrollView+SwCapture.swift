//
//  UIScrollView+SwCapture.swift
//  SwViewCapture
//
//  Created by chenxing.cx on 16/2/26.
//  Copyright © 2016年 Startry. All rights reserved.
//

import Foundation
import WebKit

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
        
        // Sometimes ScrollView will Capture nothing without defer;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            let bounds = self.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
            
            if (self.swContainsWKWebView()) {
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
    
    
    // Simulate People Action, all the `fixed` element will be repeate
    // SwContentCapture will capture all content without simulate people action, more perfect.
    public func swContentScrollCapture (completionHandler: (capturedImage: UIImage?) -> Void) {
        
        self.isCapturing = true
        
        // Put a fake Cover of View
        let snapShotView = self.snapshotViewAfterScreenUpdates(true)
        snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        
        // Backup
        let bakOffset    = self.contentOffset
        
        // Divide
        let page  = floorf(Float(self.contentSize.height / self.bounds.height))
        
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.mainScreen().scale)
        
        self.swContentScrollPageDraw(0, maxIndex: Int(page), drawCallback: { [weak self] () -> Void in
            let strongSelf = self
            
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Recover
            strongSelf?.setContentOffset(bakOffset, animated: false)
            snapShotView.removeFromSuperview()
            
            strongSelf?.isCapturing = false
            
            completionHandler(capturedImage: capturedImage)
            })
        
    }
    
    private func swContentScrollPageDraw (index: Int, maxIndex: Int, drawCallback: () -> Void) {
        
        self.setContentOffset(CGPointMake(0, CGFloat(index) * self.frame.size.height), animated: false)
        let splitFrame = CGRectMake(0, CGFloat(index) * self.frame.size.height, bounds.size.width, bounds.size.height)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.drawViewHierarchyInRect(splitFrame, afterScreenUpdates: true)
            
            if index < maxIndex {
                self.swContentScrollPageDraw(index + 1, maxIndex: maxIndex, drawCallback: drawCallback)
            }else{
                drawCallback()
            }
        }
    }
}

public extension UIWebView {
    
    public func swContentCapture (completionHandler: (capturedImage: UIImage?) -> Void) {
        self.scrollView.swContentCapture(completionHandler)
    }
    
    public func swContentScrollCapture (completionHandler: (capturedImage: UIImage?) -> Void) {
        self.scrollView.swContentScrollCapture(completionHandler)
    }
    
}
