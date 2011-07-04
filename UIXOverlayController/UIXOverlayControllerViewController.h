//
//  UIXOverlayControllerViewController.h
//  UIXOverlayController
//
//  Created by Guy Umbright on 5/29/11.
//  Copyright 2011 Kickstand Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIXOverlayController.h"

@interface UIXOverlayControllerViewController : UIViewController 
{
    UIXOverlayController* overlay;
}

- (IBAction) showDialog:(id) sender;

@end
