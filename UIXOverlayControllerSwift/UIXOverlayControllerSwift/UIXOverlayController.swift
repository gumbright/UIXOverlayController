//
//  UIXOverlayController.swift
//  UIXOverlayControllerSwift
//
//  Created by Guy Umbright on 5/6/15.
//  Copyright (c) 2015 Umbright Consulting, Inc. All rights reserved.
//

import UIKit

let DISMISS_MASK = "OverlayControllerDismissMask"

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
class UIXOverlayMaskView : UIView
{
    
}


@objc protocol UIXOverlayControllerDelegate
{
//optional
    optional func overlayWillDisplayContent(overlayController:UIXOverlayController)
    optional func overlayContentDisplayed(overlayController:UIXOverlayController)
    optional func overlayMaskTouched(overlayController:UIXOverlayController)

//required

    func overlayRemoved(overlayController:UIXOverlayController)
}

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
class UIXOverlayController : NSObject
{
    var _parent : UIView?
    var _contentController : UIXOverlayContentViewController?
    var overlayDelegate : UIXOverlayControllerDelegate?
    var maskView : UIXOverlayMaskView?
    var parent : UIView?
    var dismissUponTouchMask : Bool = true
    var maskColor : UIColor?
    
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func dismissOverlay(animated:Bool)
    {
        _contentController!.view.removeFromSuperview();
        
        if (animated)
        {            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.maskView!.alpha = 0.0;
                }, completion: { (flag) -> Void in
                self.completeDismiss()
            })
        }
        else
        {
            self.completeDismiss()
        }
        
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func completeDismiss()
    {
        self.detachOverlay()
    }
    
    ///////////////////////////////////////////////
    //
    ///////////////////////////////////////////////
    func maskTapped()
    {
        self.overlayDelegate?.overlayMaskTouched?(self)
        
        if self.dismissUponTouchMask
        {
            self.dismissOverlay(true)
        }
    }
    
    ///////////////////////////////////////////////
    //
    ///////////////////////////////////////////////
    func detachOverlay()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.maskView!.removeFromSuperview()
        self.maskView = nil;
        self._contentController = nil;
        
        self.overlayDelegate?.overlayRemoved(self);
    }

    ///////////////////////////////////////////////
    //
    ///////////////////////////////////////////////
    func presentOverlayOnView(parentView:UIView,  contentController:UIXOverlayContentViewController,  animated:Bool)
    {
        self._parent = parentView;
        self._contentController = contentController;
        NSNotificationCenter.defaultCenter().addObserver(self,selector:Selector("maskTapped"), name:DISMISS_MASK, object:nil);
    
    //create mask
        var frame = self._parent!.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
    
    self.maskView = UIXOverlayMaskView(frame: frame);
    
        self.maskView!.backgroundColor = (self.maskColor != nil) ? self.maskColor : UIColor(white:0.0, alpha:0.75);
    
        self._contentController!.overlayController = self; // ???:is this really required
    if (animated)
    {
        self.maskView!.alpha = 0.0;
        self._parent!.addSubview(maskView!)
    
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.maskView!.alpha = 0.5;

        }, completion: { (flag) -> Void in
            self.overlayDelegate?.overlayWillDisplayContent?(self)
            
            let frame = self._contentController!.view.frame;
            
            var placement = frame;
            placement.origin.x = (self._parent!.frame.size.width - placement.size.width)/2;
            placement.origin.y = (self._parent!.frame.size.height - placement.size.height)/2;
            
            self._contentController!.view.frame = placement;
            self._contentController!.view.alpha = 0.0;
            
            self.maskView!.addSubview(self._contentController!.view);
            
            UIView.animateWithDuration(0.25, animations:{ () -> Void in
                self._contentController!.view.alpha = 1.0;
                self.maskView!.alpha = 1.0;
                },
                completion:{(flag) -> Void in
                        self.overlayDelegate?.overlayContentDisplayed?(self)
            })

        })
    }
    else
    {
        self._parent!.addSubview(self.maskView!)
    
        let frame = self._contentController!.view.frame;
    
        var placement = frame;
        placement.origin.x = (self._parent!.frame.size.width - placement.size.width)/2;
        placement.origin.y = (self._parent!.frame.size.height - placement.size.height)/2;
    
        self._contentController!.view.frame = placement;
        
        self.maskView!.addSubview(self._contentController!.view);
    
    }
    }

}

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
class UIXOverlayContentViewController : UIViewController
{
    var overlayController : UIXOverlayController?
}

