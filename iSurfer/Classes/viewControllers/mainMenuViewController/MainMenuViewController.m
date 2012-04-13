//
//  MainMenuViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"

//--------------------------------------------------------------------------------------------------------
@implementation MainMenuViewController
//--------------------------------------------------------------------------------------------------------
@synthesize buttonsView;
//--------------------------------------------------------------------------------------------------------
-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"MainMenuViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
	[self.buttonsView setAlpha:0];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.6];
	[self.buttonsView setAlpha:1];
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------

-(IBAction)buttonPressed:(id)sender{
	UIButton* buttonclicked = (UIButton*)sender;
	NSString* controllerName;
	switch (buttonclicked.tag) {
		case GO_ISURFER_BUTTON:
			controllerName = @"goiSurfer";
			break;
		case MY_GALLERIES_BUTTON:
			controllerName = @"myGalleries";
			break;
		case HELP_BUTTON:
			controllerName = @"help";
			break;
		case OTHER_BUTTON:
			controllerName = @"other";
			break;
		default:
            controllerName = @"other";
			break;
	}
	[appcontroller pushViewControllerWithName:controllerName];
}

//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[super dealloc];
	[buttonsView release];
}
//--------------------------------------------------------------------------------------------------------
@end
