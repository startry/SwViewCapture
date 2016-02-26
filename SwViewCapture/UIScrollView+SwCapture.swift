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
