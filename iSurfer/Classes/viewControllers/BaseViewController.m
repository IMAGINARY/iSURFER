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

@synthesize appcontroller;
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

-(void)dealloc{
	[super dealloc];
	[appcontroller release];
}
//---------------------------------------------------------------------------------------------

@end
