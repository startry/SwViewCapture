//
//  ImageViewController.swift
//  Example
//
//  Created by chenxing.cx on 16/2/17.
//  Copyright © 2016年 Startry. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var scrollView: UIScrollView?
    var imageView: UIImageView?
    var image: UIImage?
    
    init(image: UIImage){
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView = UIImageView()
        self.imageView?.image = image
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.scrollView = UIScrollView()
        
        self.scrollView?.addSubview(self.imageView!)
        self.view.addSubview(self.scrollView!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if image?.size.height == UIScreen.mainScreen().bounds.height {
            self.scrollView?.setContentOffset(CGPointMake(0, (self.scrollView?.contentSize.height)! - (self.scrollView?.frame.size.height)!), animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = (self.image?.size.height)!
        let width  = (self.image?.size.width)!
        
        self.scrollView?.frame = self.view.bounds
        self.scrollView?.contentSize = CGSizeMake(width, height)
        
        self.imageView?.frame = CGRectMake(0, 0, width, height)
    }
}
