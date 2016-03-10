//
//  STTableViewDemoController.swift
//  STViewCapture
//
//  Created by chenxing.cx on 15/10/28.
//  Copyright © 2015年 startry.com All rights reserved.
//

import UIKit

class STTableViewDemoController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentify = "resuseableCellIdentify"
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Capture", style: UIBarButtonItemStyle.Plain, target: self, action: "didCaptureBtnClicked:")
        
        tableView = UITableView() // tableView
        
        tableView?.dataSource = self
        tableView?.delegate   = self
        
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentify)
        
        view.addSubview(tableView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = view.bounds
    }
    
    // MARK: TableView DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify)
        
        cell?.textLabel?.text = "show cell \(indexPath.row)"
        
        return cell!
    }
    
    // MARK : Events
    func didCaptureBtnClicked(button: UIButton){
        
        tableView?.swContentCapture({ (capturedImage) -> Void in
            let vc = ImageViewController(image: capturedImage!)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
//        tableView?.swContentScrollCapture({ (capturedImage) -> Void in
//            let vc = ImageViewController(image: capturedImage!)
//            self.navigationController?.pushViewController(vc, animated: true)
//        })
    }
    
}
