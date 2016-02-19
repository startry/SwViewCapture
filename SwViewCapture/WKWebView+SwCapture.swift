//
//  WKWebView+SwCapture.swift
//  SwViewCapture
//
//  Created by chenxing.cx on 16/2/19.
//  Copyright © 2016年 Startry. All rights reserved.
//

import Foundation
import WebKit
import ObjectiveC

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
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
            
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
    
    // BUG: Exists a problem, position: fixed property problem.
    public func swContentCompCapture (completionHandler: (capturedImage: UIImage?) -> Void) {
        // Put a fake Cover of View
        let snapShotView = self.snapshotViewAfterScreenUpdates(true)
        snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        
        // Backup
        let bakOffset    = self.scrollView.contentOffset
        
        // Divide
        let page  = floorf(Float(self.scrollView.contentSize.height / self.bounds.height))
        
        UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, false, UIScreen.mainScreen().scale)
        
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
