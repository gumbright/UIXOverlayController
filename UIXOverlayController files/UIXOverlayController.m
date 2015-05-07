    //
//  OverlayController.m
//  NextiPad
//
//  Created by gumbright on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIXOverlayController.h"

#define DISMISS_MASK		@"OverlayControllerDismissMask"

@implementation UIXOverlayMaskView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:DISMISS_MASK object:nil];
}

@end


@implementation UIXOverlayController

@synthesize overlayDelegate;
@synthesize parent;
@synthesize dismissUponTouchMask;
@synthesize maskColor;

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        self.dismissUponTouchMask = YES;
    }
    return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void)viewDidUnload 
{
	// ???: call the content controller version?
//    [super viewDidUnload];
}


///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void)dealloc 
{
    if (maskView.superview != nil)
    {
        [maskView removeFromSuperview];
    }
}

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (_contentController) {
		int width = 0;
		int height = 0;
		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			width = 768;
			height = 1024;
		} else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			width = 1024;
			height = 768;
		}
		
		maskView.frame = CGRectMake(0, 0, width, height);
		[_contentController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];	
	}
}

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void)maskFadeInComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([overlayDelegate respondsToSelector:@selector(overlayWillDisplayContent:)])
    {
        [overlayDelegate overlayWillDisplayContent:self];
    }

	CGRect frame = _contentController.view.frame;
	
	CGRect placement = frame;
	placement.origin.x = (_parent.frame.size.width - placement.size.width)/2;
	placement.origin.y = (_parent.frame.size.height - placement.size.height)/2;
	
	_contentController.view.frame = placement;
	_contentController.view.alpha = 0.0;
    
	[maskView addSubview:_contentController.view];
    
    [UIView animateWithDuration:0.25 
                     animations:^(void) {
                            _contentController.view.alpha = 1.0;
                            maskView.alpha = 1.0;
                        } 
                     completion:^(BOOL finished) {
                        if ([overlayDelegate respondsToSelector:@selector(overlayContentDisplayed:)])
                        {
                            [overlayDelegate overlayContentDisplayed:self];
                        }
                        if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0)
                        {
                            [_contentController viewDidAppear:YES];
                        }
    }];
    
}

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void) detachOverlay 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[maskView removeFromSuperview];
    maskView = nil;
	_contentController = nil;
    
    if ([overlayDelegate respondsToSelector:@selector(overlayRemoved:)])
    {
        [overlayDelegate overlayRemoved:self];
    }
}

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void)maskFadeOutComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0)
    {
        [_contentController viewDidDisappear:YES];
    }
    [self detachOverlay];
}	

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void) presentOverlayOnView:(UIView*) parentView withContent:(UIXOverlayContentViewController*) contentController animated:(BOOL) animated
{
	_parent = parentView;
	_contentController = contentController;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maskTapped) name:DISMISS_MASK object:nil];
	
	//create mask
	CGRect frame = _parent.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	
	maskView = [[UIXOverlayMaskView alloc] initWithFrame:frame];
    
	maskView.backgroundColor = (self.maskColor != nil) ? self.maskColor : [UIColor colorWithWhite:.0 alpha:.75];
	
    contentController.overlayController = self; // ???:is this really required
	if (animated)
	{
		maskView.alpha = 0.0;
		[_parent addSubview:maskView];
		
		[UIView beginAnimations:@"maskfadein" context:nil];
		[UIView setAnimationDidStopSelector:@selector(maskFadeInComplete:finished:context:)];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.25];
		maskView.alpha = 0.5;
		[UIView commitAnimations];
	}
	else 
	{
		[_parent addSubview:maskView];
		
		frame = _contentController.view.frame;
		
		CGRect placement = frame;
		placement.origin.x = (_parent.frame.size.width - placement.size.width)/2;
		placement.origin.y = (_parent.frame.size.height - placement.size.height)/2;
		
		_contentController.view.frame = placement;
		
		[maskView addSubview:_contentController.view];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0)
        {
            [contentController viewDidAppear:NO];
        }
	}
}

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void)maskTapped 
{
    if ([overlayDelegate respondsToSelector:@selector(overlayMaskTouched:)])
    {
        [overlayDelegate overlayMaskTouched:self];
    }

    if (self.dismissUponTouchMask) 
    {
	[self dismissOverlay:YES];	
    }
}

///////////////////////////////////////////////
//
///////////////////////////////////////////////
- (void) dismissOverlay:(BOOL) animated;
{
	[_contentController.view removeFromSuperview];
	
	if (animated)
	{
		[UIView beginAnimations:@"maskfadeout" context:nil];
		[UIView setAnimationDidStopSelector:@selector(maskFadeOutComplete:finished:context:)];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		maskView.alpha = 0.0;
		[UIView commitAnimations];
	}
	else
	{
        if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0)
        {
            [_contentController viewDidDisappear:NO];
        }
        [self detachOverlay];
	}	
}

@end

@implementation UIXOverlayContentViewController

@synthesize overlayController;


@end
