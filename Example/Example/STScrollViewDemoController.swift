//
//  STScrollViewDemoController.swift
//  STViewCapture
//
//  Created by chenxing.cx on 15/10/28.
//  Copyright © 2015年 startry.com All rights reserved.
//

import UIKit
import WebKit

class STScrollViewDemoController: UIViewController {
        
    // MARK: Life Cycle
    
    var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Capture", style: UIBarButtonItemStyle.Plain, target: self, action: "didCaptureBtnClicked:")
        
        // Add Some Color View for Capture
        let orangeView = UIView(frame: CGRectMake(30, 100, 100, 100))
        let redView = UIView(frame: CGRectMake(30, 200, 100, 100))
        
        let headImage = UIImage(named: "demo_2")
        let headImageView = UIImageView(frame: CGRectMake(30, 300, headImage!.size.width / 2, headImage!.size.height / 2))
        headImageView.image = headImage
        
        let sceneImage = UIImage(named: "demo_1")
        let sceneImageView = UIImageView(frame: CGRectMake(30, 500, sceneImage!.size.width / 2, sceneImage!.size.height / 2))
        sceneImageView.image = sceneImage
        
        let url = NSURL(string: "http://www.startry.com")
        let request = NSURLRequest(URL: url!)
        let webView = WKWebView(frame: CGRectMake(0, 600, self.view.frame.size.width, 100))
        webView.loadRequest(request)
            
        orangeView.backgroundColor = UIColor.orangeColor()
        redView.backgroundColor = UIColor.redColor()
        
        scrollView = UIScrollView()
        scrollView?.backgroundColor = UIColor.orangeColor()
        scrollView?.contentSize = CGSizeMake(view.bounds.width, 800)
        
        scrollView?.addSubview(orangeView)
        scrollView?.addSubview(redView)
        scrollView?.addSubview(headImageView)
        scrollView?.addSubview(sceneImageView)
        scrollView?.addSubview(webView)
        
        view.addSubview(scrollView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView?.frame = view.bounds
    }
    
    // MARK: Events
    
    func didCaptureBtnClicked(button: UIButton){
        
        scrollView?.swContentCapture({ (capturedImage) -> Void in
            
            UIImageWriteToSavedPhotosAlbum(capturedImage!, self, nil, nil)
            
            let vc = ImageViewController(image: capturedImage!)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
//        scrollView?.swContentScrollCapture({ (capturedImage) -> Void in
//            
//            UIImageWriteToSavedPhotosAlbum(capturedImage!, self, nil, nil)
//            
//            let vc = ImageViewController(image: capturedImage!)
//            self.navigationController?.pushViewController(vc, animated: true)
//        })
    }
    
}
