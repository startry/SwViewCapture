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
        
        let offset = self.scrollView.contentOffset
        
        // Put a fake Cover of View
        let snapShotView = self.snapshotViewAfterScreenUpdates(true)
        snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        
        if self.frame.size.height < self.scrollView.contentSize.height {
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.frame.size.height)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.scrollView.contentOffset = CGPointZero
            
            self.swContentCaptureWithoutOffset({ [weak self] (capturedImage) -> Void in
                let strongSelf = self!
                
                strongSelf.scrollView.contentOffset = offset
                
                snapShotView.removeFromSuperview()
                
                strongSelf.isCapturing = false
                
                completionHandler(capturedImage: capturedImage)
            })
        }
    }
    
    private func swContentCaptureWithoutOffset(completionHandler:(capturedImage: UIImage?) -> Void) {
        let containerView  = UIView(frame: self.bounds)
        
        let bakFrame     = self.frame
        let bakSuperView = self.superview
        let bakIndex     = self.superview?.subviews.indexOf(self)
        
        // remove WebView from superview & put container view
        self.removeFromSuperview()
        containerView.addSubview(self)
        
        let totalSize = self.scrollView.contentSize
        
        // Divide
        let page       = floorf(Float( totalSize.height / containerView.bounds.height))
        
        self.frame = CGRectMake(0, 0, containerView.bounds.size.width, self.scrollView.contentSize.height)

        UIGraphicsBeginImageContextWithOptions(totalSize, false, UIScreen.mainScreen().scale)
        
        self.swContentPageDraw(containerView, index: 0, maxIndex: Int(page), drawCallback: { [weak self] () -> Void in
            let strongSelf = self!
            
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Recover
            strongSelf.removeFromSuperview()
            bakSuperView?.insertSubview(strongSelf, atIndex: bakIndex!)
            
            strongSelf.frame = bakFrame
            
            containerView.removeFromSuperview()
            
            completionHandler(capturedImage: capturedImage)
        })
    }
    
    private func swContentPageDraw (targetView: UIView, index: Int, maxIndex: Int, drawCallback: () -> Void) {
        
        // set up split frame of super view
        let splitFrame = CGRectMake(0, CGFloat(index) * targetView.frame.size.height, targetView.bounds.size.width, targetView.frame.size.height)
        // set up webview frame
        var myFrame = self.frame
        myFrame.origin.y = -(CGFloat(index) * targetView.frame.size.height)
        self.frame = myFrame
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            targetView.drawViewHierarchyInRect(splitFrame, afterScreenUpdates: true)
            
            if index < maxIndex {
                self.swContentPageDraw(targetView, index: index + 1, maxIndex: maxIndex, drawCallback: drawCallback)
            }else{
                drawCallback()
            }
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
        let bakOffset    = self.scrollView.contentOffset
        
        // Divide
        let page  = floorf(Float(self.scrollView.contentSize.height / self.bounds.height))
        
        UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, false, UIScreen.mainScreen().scale)
        
        self.swContentScrollPageDraw(0, maxIndex: Int(page), drawCallback: { [weak self] () -> Void in
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
    
    private func swContentScrollPageDraw (index: Int, maxIndex: Int, drawCallback: () -> Void) {
        
        self.scrollView.setContentOffset(CGPointMake(0, CGFloat(index) * self.scrollView.frame.size.height), animated: false)
        let splitFrame = CGRectMake(0, CGFloat(index) * self.scrollView.frame.size.height, bounds.size.width, bounds.size.height)
        
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
