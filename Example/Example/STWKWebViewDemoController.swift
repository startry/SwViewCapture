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
        
        webView = WKWebView()
        let url = NSURL(string: "http://stackoverflow.com")
        let request = NSURLRequest(URL: url!)
        webView?.loadRequest(request)
        
        view.addSubview(webView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView?.frame = self.view.bounds
    }
    
    // MARK: Events
    func didCaptureBtnClicked(button: UIButton){
        
        webView?.swContentCapture({ (capturedImage) -> Void in
            let vc = ImageViewController(image: capturedImage!)
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
