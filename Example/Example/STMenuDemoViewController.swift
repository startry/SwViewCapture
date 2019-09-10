//
//  STMenuDemoViewController.swift
//  STViewCapture
//
//  Created by chenxing.cx on 15/10/28.
//  Copyright © 2015年 startry.com All rights reserved.
//

import UIKit

class STMenuDemoViewController: UIViewController {
    
    fileprivate var viewBtn: UIButton?
    fileprivate var scrollViewBtn: UIButton?
    fileprivate var tableViewBtn: UIButton?
    fileprivate var webViewBtn: UIButton?
    fileprivate var oldWebViewBtn: UIButton?
    fileprivate var collectionBtn: UIButton?
    
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
    
    fileprivate func initViews(){
        view.backgroundColor = UIColor.white
        
        let viewBtn = UIButton()
        let scrollViewBtn = UIButton()
        let tableViewBtn  = UIButton()
        let webViewBtn    = UIButton()
        let oldWebViewBtn = UIButton()
        let collectBtn    = UIButton()
        
        viewBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        scrollViewBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        tableViewBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        webViewBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        oldWebViewBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        collectBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
        viewBtn.setTitle("View示例", for: UIControl.State.normal)
        scrollViewBtn.setTitle("ScrollView示例", for: UIControl.State.normal)
        tableViewBtn.setTitle("TableView示例", for: UIControl.State.normal)
        webViewBtn.setTitle("WKWebView示例", for: UIControl.State.normal)
        oldWebViewBtn.setTitle("UIWebView示例", for: UIControl.State.normal)
        collectBtn.setTitle("CollectionView示例", for: UIControl.State.normal)
        
        view.addSubview(viewBtn)
        view.addSubview(scrollViewBtn)
        view.addSubview(tableViewBtn)
        view.addSubview(webViewBtn)
        view.addSubview(oldWebViewBtn)
        view.addSubview(collectBtn)
        
        let actionSel = #selector(STMenuDemoViewController.didBtnClicked(_:))
        
        viewBtn.addTarget(self, action: actionSel, for: UIControl.Event.touchUpInside)
        scrollViewBtn.addTarget(self, action: actionSel, for: UIControl.Event.touchUpInside)
        tableViewBtn.addTarget(self, action: actionSel, for: UIControl.Event.touchUpInside)
        webViewBtn.addTarget(self, action: actionSel, for: UIControl.Event.touchUpInside)
        oldWebViewBtn.addTarget(self, action: actionSel, for: UIControl.Event.touchUpInside)
        collectBtn.addTarget(self, action: actionSel, for: UIControl.Event.touchUpInside)
        
        self.viewBtn = viewBtn
        self.scrollViewBtn = scrollViewBtn
        self.tableViewBtn = tableViewBtn
        self.webViewBtn = webViewBtn
        self.oldWebViewBtn = oldWebViewBtn
        self.collectionBtn = collectBtn;
    }
    
// MARK: Layout Views
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let btnHeight:CGFloat = 30, btnWidth:CGFloat = 180.0, spanHeight:CGFloat = 20.0;
        let btnX = view.frame.size.width / 2 - btnWidth / 2;
        let midY = view.frame.size.height / 2;
        
        viewBtn?.frame       = CGRect(x: btnX, y: midY - btnHeight * 3 - spanHeight * 2.5, width: btnWidth, height: btnHeight)
        scrollViewBtn?.frame = CGRect(x: btnX, y: midY - btnHeight * 2 - spanHeight * 1.5, width: btnWidth, height: btnHeight)
        tableViewBtn?.frame  = CGRect(x: btnX, y: midY - btnHeight - spanHeight / 2, width: btnWidth, height: btnHeight)
        
        webViewBtn?.frame    = CGRect(x: btnX, y: midY + spanHeight * 0.5, width: btnWidth, height: btnHeight)
        oldWebViewBtn?.frame = CGRect(x: btnX, y: midY + spanHeight * 1.5 + btnHeight, width: btnWidth, height: btnHeight)
        collectionBtn?.frame = CGRect(x: btnX, y: midY + spanHeight * 2.5 + btnHeight * 2, width: btnWidth, height: btnHeight)
    }
    
// MARK: Events
    
    @objc func didBtnClicked(_ button: UIButton){
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
        }else if(button == collectionBtn) {
            let vc = STCollectionViewDemoController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
