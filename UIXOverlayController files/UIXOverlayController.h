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
	
	NSObject<UIXOverlayControllerDelegate>* __weak overlayDelegate;
	
	UIXOverlayMaskView* maskView;
}

- (void) presentOverlayOnView:(UIView*) parent 
                  withContent:(UIXOverlayContentViewController*) contentController 
                     animated:(BOOL) animated;
- (void) dismissOverlay:(BOOL) animated;
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@property (nonatomic, strong, readonly)  UIView* parent;
@property (assign) BOOL dismissUponTouchMask;

@property (nonatomic, strong) UIColor* maskColor;

@property (nonatomic, weak) NSObject<UIXOverlayControllerDelegate>* overlayDelegate;

@end

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
@interface UIXOverlayContentViewController : UIViewController 
{
}

@property (nonatomic, strong) UIXOverlayController* overlayController;

@end
