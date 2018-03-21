//
//  STCollectionViewDemoController.swift
//  Example
//
//  Created by chenxing.cx on 2017/6/7.
//  Copyright © 2017年 Startry. All rights reserved.
//

import UIKit

class STCollectionViewDemoController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    let cellIdentify = "reuseableCellIdentify"
    var collectView : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Capture", style: UIBarButtonItemStyle.plain, target: self, action: #selector(STTableViewDemoController.didCaptureBtnClicked(_:)))
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical;
        collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        collectView?.dataSource = self
        collectView?.delegate   = self
        
        collectView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentify)
        
        view.addSubview(collectView!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectView?.frame = view.bounds
    }
    
    // MARK: UICollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 500;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath);
        
        if indexPath.row % 2 == 1 {
            cell?.contentView.backgroundColor = UIColor.orange
        }else {
            cell?.contentView.backgroundColor = UIColor.yellow
        }
        
        return cell!;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }

    // MARK : Capture Button Events
    @objc func didCaptureBtnClicked(_ button: UIButton){
        
        collectView?.swContentCapture({ (capturedImage) -> Void in
            let vc = ImageViewController(image: capturedImage!)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        //        tableView?.swContentScrollCapture({ (capturedImage) -> Void in
        //            let vc = ImageViewController(image: capturedImage!)
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        })
    }
}
