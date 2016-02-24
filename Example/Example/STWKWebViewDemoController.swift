//
//  STWKWebViewDemoController.swift
//  STViewCapture
//
//  Created by chenxing.cx on 15/10/28.
//  Copyright © 2015年 startry.com All rights reserved.
//

import UIKit
import WebKit

class STWKWebViewDemoController: UIViewController {
    
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Capture", style: UIBarButtonItemStyle.Plain, target: self, action: "didCaptureBtnClicked:")
        
        webView = WKWebView(frame: self.view.bounds)
        let url = NSURL(string: "http://www.startry.com")
        let request = NSURLRequest(URL: url!)
        webView?.loadRequest(request)
        
        view.addSubview(webView!)
    }

//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        self.didCaptureBtnClicked(nil)
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        webView?.frame = self.view.bounds
    }
    
    // MARK: Events
    func didCaptureBtnClicked(button: UIButton?){
        
        webView?.swContentCapture({ (capturedImage) -> Void in
            
            UIImageWriteToSavedPhotosAlbum(capturedImage!, self, nil, nil)

            let vc = ImageViewController(image: capturedImage!)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
}
