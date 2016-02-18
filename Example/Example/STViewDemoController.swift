//
//  STViewDemoController.swift
//  STViewCapture
//
//  Created by chenxing.cx on 10/28/2015.
//  Copyright (c) 2015 startry.com All rights reserved.
//

import UIKit
import SwViewCapture

class STViewDemoController: UIViewController {
    
// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellowColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Capture", style: UIBarButtonItemStyle.Plain, target: self, action: "didCaptureBtnClicked:")
        
        // Add Some Color View for Capture
        let orangeView = UIView(frame: CGRectMake(100, 100, 20, 50))
        let redView = UIView(frame: CGRectMake(150, 200, 100, 100))
        
        let headImage = UIImage(named: "demo_2")
        let headImageView = UIImageView(frame: CGRectMake(30, 300, headImage!.size.width, headImage!.size.height))
        headImageView.image = headImage
        
        orangeView.backgroundColor = UIColor.orangeColor()
        redView.backgroundColor = UIColor.redColor()
        
        view.addSubview(orangeView)
        view.addSubview(redView)
        view.addSubview(headImageView)
    }
    
// MARK: Events
    
    func didCaptureBtnClicked(button: UIButton){
        
        view.swCapture { (capturedImage) -> Void in
            let vc = ImageViewController(image: capturedImage!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

