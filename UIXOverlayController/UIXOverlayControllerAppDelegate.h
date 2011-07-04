//
//  UIXOverlayControllerAppDelegate.h
//  UIXOverlayController
//
//  Created by Guy Umbright on 5/29/11.
//  Copyright 2011 Kickstand Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIXOverlayControllerViewController;

@interface UIXOverlayControllerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UIXOverlayControllerViewController *viewController;

@end
