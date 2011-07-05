//
//  HelpViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController
//------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}
//------------------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
	[self.movieView setAlpha:0.0];
	[super viewWillAppear:animated];
}
//------------------------------------------------------------------------------

-(void)dealloc{
	[super dealloc];
}
//------------------------------------------------------------------------------
-(void)showVideoAnimated:(BOOL)boolean{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	if( boolean ){
		[self.movieView setAlpha:1];	
	}else {
		[self.movieView setAlpha:0];	
	}
	[UIView commitAnimations];	
}
//-----------------------------------------------------------------------------

-(IBAction)playVideo2{
	if( self.movie == NULL ){
		[self loadMovieFromWebURL:@"http://temp.imaginary2008.de//Video-Surfer-DVPAL-16-9.mp4"];	
	}else {
		[self playVideo];
	}
}
//------------------------------------------------------------------------------

-(void)playVideo{
	NSLog(@"help playvideo");
	[self showVideoAnimated:YES];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[super playVideo];
}
//------------------------------------------------------------------------------
- (void) movieFinishedCallback:(NSNotification*) aNotification {
	NSLog(@"Help movieFinishedCallback");
	[self showVideoAnimated:NO];
	[super movieFinishedCallback:aNotification];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

//------------------------------------------------------------------------------
@end
