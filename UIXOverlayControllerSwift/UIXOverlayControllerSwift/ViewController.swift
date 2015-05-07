//
//  ViewController.swift
//  UIXOverlayControllerSwift
//
//  Created by Guy Umbright on 5/6/15.
//  Copyright (c) 2015 Umbright Consulting, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showOverlay(sender: AnyObject)
    {
        var overlay = UIXOverlayController()
        overlay.dismissUponTouchMask = false;
        
        let vc = DialogContentController()
        
        overlay.presentOverlayOnView(self.view, contentController:vc, animated:true);
    }

}

