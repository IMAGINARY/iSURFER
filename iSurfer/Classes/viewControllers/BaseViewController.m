//
//  BaseViewController.m
//  cards
//
//  Created by Damian Modernell on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#include <QuartzCore/QuartzCore.h>

//---------------------------------------------------------------------------------------------
@implementation BaseViewController
//---------------------------------------------------------------------------------------------
@synthesize appcontroller, opaqueView, activityView;
//---------------------------------------------------------------------------------------------



-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"MyGalleriesViewController" bundle:[NSBundle mainBundle]]) {
		
		[self setAppcontroller:anappCtrl];
        
	}
	return self;
}


- (void) scrollViewTo:(UIView*)theView movePixels:(int)pixels baseView:(UIView*)baseview{	
	NSLog(@"scrollview");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect thisViewFrame = [baseview frame];
	if (theView) {
		
		CGRect targetViewFrame = [theView frame];
		thisViewFrame.origin.y = - targetViewFrame.origin.y + pixels;
		
	} else {
		thisViewFrame.origin.y = 0;
	}
	
	[baseview setFrame:thisViewFrame];
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

-(void)viewDidLoad{
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	[super viewDidLoad];
}
//---------------------------------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self
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
	[[NSNotificationCenter defaultCenter] addObserver:self
											  selector:@selector(keyboardDidHide:)
												  name:UIKeyboardDidHideNotification
												object:nil];
}
//---------------------------------------------------------------------------------------------

- (void) keyboardDidHide: (NSNotification *) notification {	
	
}


- (void) keyboardWillHide: (NSNotification *) notification {	
	[self scrollViewTo:nil movePixels:0 baseView:self.view];
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

-(void)setLoadingScreenVisible:(BOOL)yes{
	
	if( yes ){
		UIView *tmpView = [[UIView alloc] initWithFrame:[self.view frame]];
		[self setOpaqueView:tmpView];
		[tmpView release];
		UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];	
		[self setActivityView:loadingView];
		[loadingView release];
		
		[opaqueView setBackgroundColor:[UIColor blackColor]];
		[opaqueView setAlpha:0];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[self.opaqueView setAlpha:0.4];

		[self.view addSubview:opaqueView];
		[self.opaqueView addSubview:activityView];
		[self.view bringSubviewToFront:opaqueView];
		[self.opaqueView bringSubviewToFront:activityView];
		[self.activityView startAnimating];
		CGRect fv = [self.view frame];
		CGRect fa = [activityView frame];
		fa.origin.x = (fv.size.width - fa.size.width) / 2;
		fa.origin.y = (fv.size.height - fa.size.height) / 2;
		[activityView setFrame:fa];
	}else{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[self.activityView stopAnimating];
		[opaqueView setAlpha:0];
	}
	
	[UIView commitAnimations];
	
	if( !yes && opaqueView && activityView){
		[self.activityView removeFromSuperview];
		[self.opaqueView removeFromSuperview];
		self.opaqueView = nil;
		self.activityView = nil;
	}
}
//------------------------------------------------------------------------------

-(IBAction)goBack{
	[self.appcontroller goBack];
}
//---------------------------------------------------------------------------------------------

-(void)dealloc{
	[opaqueView release];
	[activityView release];
	[super dealloc];
}
//---------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[self scrollViewTo:textField movePixels:70 baseView:self.view];
  	return YES;
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}
//--------------------------------------------------------------------------------------------------------


- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
