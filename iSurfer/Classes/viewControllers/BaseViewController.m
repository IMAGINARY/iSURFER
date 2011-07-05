//
//  BaseViewController.m
//  cards
//
//  Created by Damian Modernell on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#include <QuartzCore/QuartzCore.h>


@implementation BaseViewController
//---------------------------------------------------------------------------------------------

@synthesize appcontroller, opaqueView;
//---------------------------------------------------------------------------------------------

- (void) scrollViewTo:(UIView*)theView movePixels:(int)pixels{	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect thisViewFrame = [self.view frame];
	
	if (theView) {
		
		CGRect targetViewFrame = [theView frame];
		thisViewFrame.origin.y = - targetViewFrame.origin.y + pixels;
		
	} else {
		thisViewFrame.origin.y = 0;
	}
	
	[self.view setFrame:thisViewFrame];
	[UIView commitAnimations];
	
}

//---------------------------------------------------------------------------------------------

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
//---------------------------------------------------------------------------------------------

- (UIImage *)captureView:(UIView *)theView {
    CGRect screenRect = [theView frame];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [(CALayer*)[theView layer] renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
    return newImage;
}
//---------------------------------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter]	 addObserver:self
											  selector:@selector(keyboardWillHide:)
												  name:UIKeyboardWillHideNotification
												object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];	

        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardDidShow:) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];
}


//---------------------------------------------------------------------------------------------

- (void) keyboardWillHide: (NSNotification *) notification {	
	[self scrollViewTo:nil movePixels:0];
}
//---------------------------------------------------------------------------------------------
- (void) keyboardDidShow: (NSNotification *) notification {	

}
//---------------------------------------------------------------------------------------------

- (void) keyboardWillShow: (NSNotification *) notification {	
}
//---------------------------------------------------------------------------------------------

-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
//---------------------------------------------------------------------------------------------


-(void)popUpView:(UIView*) theView{
	
	UIView *tmpView = [[UIView alloc] initWithFrame:[self.view frame]];
	[self setOpaqueView:tmpView];
	[tmpView release];
	
	[opaqueView setBackgroundColor:[UIColor blackColor]];
	[opaqueView setAlpha:0];
	[opaqueView setHidden:NO];
	[theView setAlpha:0];
	[theView setHidden:NO];
	
	
	[self.view addSubview:opaqueView];
	[self.view bringSubviewToFront:opaqueView];
	[self.view bringSubviewToFront:theView];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[self.opaqueView setAlpha:0.4];
	
	[theView setAlpha:1];
	
	[UIView commitAnimations];
	
}
//------------------------------------------------------------------------------

-(void)popDownView:(UIView*)theView{
	NSLog(@"popdown");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[self.opaqueView setAlpha:0];
	[theView setAlpha:0];
	
	[UIView commitAnimations];
	[self.opaqueView removeFromSuperview];
	
}
//---------------------------------------------------------------------------------------------


-(void)dealloc{
	[appcontroller release];
	[opaqueView release];
	[super dealloc];
}
//---------------------------------------------------------------------------------------------

@end
