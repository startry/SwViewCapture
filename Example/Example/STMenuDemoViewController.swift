//
//  STMenuDemoViewController.swift
//  STViewCapture
//
//  Created by chenxing.cx on 15/10/28.
//  Copyright © 2015年 startry.com All rights reserved.
//

import UIKit

class STMenuDemoViewController: UIViewController {
    
    private var viewBtn: UIButton?
    private var scrollViewBtn: UIButton?
    private var tableViewBtn: UIButton?
    private var webViewBtn: UIButton?
    private var oldWebViewBtn: UIButton?
    
// MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initViews();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: Private Methods
    
    private func initViews(){
        view.backgroundColor = UIColor.whiteColor()
        
        let viewBtn = UIButton()
        let scrollViewBtn = UIButton()
        let tableViewBtn  = UIButton()
        let webViewBtn    = UIButton()
        let oldWebViewBtn = UIButton()
        
        viewBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        scrollViewBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        tableViewBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        webViewBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        oldWebViewBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        viewBtn.setTitle("View示例", forState: UIControlState.Normal)
        scrollViewBtn.setTitle("ScrollView示例", forState: UIControlState.Normal)
        tableViewBtn.setTitle("TableView示例", forState: UIControlState.Normal)
        webViewBtn.setTitle("WKWebView示例", forState: UIControlState.Normal)
        oldWebViewBtn.setTitle("UIWebView示例", forState: UIControlState.Normal)
        
        view.addSubview(viewBtn)
        view.addSubview(scrollViewBtn)
        view.addSubview(tableViewBtn)
        view.addSubview(webViewBtn)
        view.addSubview(oldWebViewBtn)
        
        let actionSel = Selector("didBtnClicked:")
        
        viewBtn.addTarget(self, action: actionSel, forControlEvents: UIControlEvents.TouchUpInside)
        scrollViewBtn.addTarget(self, action: actionSel, forControlEvents: UIControlEvents.TouchUpInside)
        tableViewBtn.addTarget(self, action: actionSel, forControlEvents: UIControlEvents.TouchUpInside)
        webViewBtn.addTarget(self, action: actionSel, forControlEvents: UIControlEvents.TouchUpInside)
        oldWebViewBtn.addTarget(self, action: actionSel, forControlEvents: UIControlEvents.TouchUpInside)
        
        self.viewBtn = viewBtn
        self.scrollViewBtn = scrollViewBtn
        self.tableViewBtn = tableViewBtn
        self.webViewBtn = webViewBtn
        self.oldWebViewBtn = oldWebViewBtn
    }
    
// MARK: Layout Views
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let btnHeight:CGFloat = 30, btnWidth:CGFloat = 180.0, spanHeight:CGFloat = 20.0;
        let btnX = view.frame.size.width / 2 - btnWidth / 2;
        let midY = view.frame.size.height / 2;
        viewBtn?.frame = CGRectMake(btnX, midY - 2 * spanHeight - btnHeight * 2.5, btnWidth, btnHeight)
        scrollViewBtn?.frame = CGRectMake(btnX, midY - spanHeight - btnHeight * 1.5, btnWidth, btnHeight)
        tableViewBtn?.frame = CGRectMake(btnX, midY - btnHeight * 0.5, btnWidth, btnHeight)
        webViewBtn?.frame = CGRectMake(btnX, midY + spanHeight + btnHeight * 0.5, btnWidth, btnHeight)
        oldWebViewBtn?.frame = CGRectMake(btnX, midY + spanHeight * 2 + btnHeight * 1.5, btnWidth, btnHeight)
    }
    
// MARK: Events
    
    func didBtnClicked(button: UIButton){
        if(button == viewBtn) {
            let vc = STViewDemoController()
            navigationController?.pushViewController(vc, animated: true)
        }else if(button == scrollViewBtn) {
            let vc = STScrollViewDemoController()
            navigationController?.pushViewController(vc, animated: true)
        }else if(button == tableViewBtn) {
            let vc = STTableViewDemoController()
            navigationController?.pushViewController(vc, animated: true)
        }else if(button == webViewBtn) {
            let vc = STWKWebViewDemoController()
//            navigationController?.presentViewController(vc, animated: true, completion: nil)
            navigationController?.pushViewController(vc, animated: true)
        }else if(button == oldWebViewBtn) {
            let vc = STUIWebViewDemoController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
