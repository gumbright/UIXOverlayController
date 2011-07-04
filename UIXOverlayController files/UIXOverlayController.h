//
//  OverlayController.h
//  NextiPad
//
//  Created by gumbright on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIXOverlayContentViewController;

@class UIXOverlayController;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
@interface UIXOverlayMaskView : UIView
{
	
}
@end


@protocol UIXOverlayControllerDelegate

//??overlay will appear
//??overlay did disappear
//??overlay mask touched
@optional
- (void) overlayWillDisplayContent:(UIXOverlayController*) overlayController;
- (void) overlayContentDisplayed:(UIXOverlayController*) overlayController;
- (void) overlayMaskTouched:(UIXOverlayController*) overlayController;

@required

- (void) overlayRemoved:(UIXOverlayController*) overlayController;

@end

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
@interface UIXOverlayController : NSObject 
{
	UIView* _parent;
	UIViewController* _contentController;
	
	NSObject<UIXOverlayControllerDelegate>* overlayDelegate;
	
	UIXOverlayMaskView* maskView;
}

- (void) presentOverlayOnView:(UIView*) parent 
                  withContent:(UIXOverlayContentViewController*) contentController 
                     animated:(BOOL) animated;
- (void) dismissOverlay:(BOOL) animated;
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@property (nonatomic, retain, readonly)  UIView* parent;
@property (assign) BOOL dismissUponTouchMask;

@property (nonatomic, retain) UIColor* maskColor;

@property (nonatomic, assign) NSObject<UIXOverlayControllerDelegate>* overlayDelegate;

@end

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
@interface UIXOverlayContentViewController : UIViewController 
{
}

@property (nonatomic, retain) UIXOverlayController* overlayController;

@end
