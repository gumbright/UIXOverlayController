//
//  DialogContentController.swift
//  UIXOverlayControllerSwift
//
//  Created by Guy Umbright on 5/7/15.
//  Copyright (c) 2015 Umbright Consulting, Inc. All rights reserved.
//

import UIKit

class DialogContentController: UIXOverlayContentViewController
{
    init()
    {
        super.init(nibName: "DialogContent", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    @IBAction func yesPressed(sender: AnyObject)
    {
        self.overlayController!.dismissOverlay(true)
    }
    
    @IBAction func noPressed(sender: AnyObject)
    {
        self.overlayController!.dismissOverlay(true)
    }
    
}