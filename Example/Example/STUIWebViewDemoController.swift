//
//  STUIWebViewDemoController.swift
//  Example
//
//  Created by chenxing.cx on 16/2/15.
//  Copyright © 2016年 Startry. All rights reserved.
//

import UIKit

class STUIWebViewDemoController: UIViewController {
    
    var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Capture", style: UIBarButtonItemStyle.Plain, target: self, action: "didCaptureBtnClicked:")
        
        webView = UIWebView(frame: view.bounds)
        let url = NSURL(string: "http://stackoverflow.com")
        let request = NSURLRequest(URL: url!)
        webView?.loadRequest(request)
        
        view.addSubview(webView!)
    }
    
    // MARK: Events
    func didCaptureBtnClicked(button: UIButton){
        webView?.swContentCapture({ (capturedImage) -> Void in
            
            UIImageWriteToSavedPhotosAlbum(capturedImage!, self, nil, nil)
            
            let vc = ImageViewController(image: capturedImage!)
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
}
