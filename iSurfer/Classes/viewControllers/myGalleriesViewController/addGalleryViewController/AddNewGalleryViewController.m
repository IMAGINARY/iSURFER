//
//  AddNewGalleryViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddNewGalleryViewController.h"


@implementation AddNewGalleryViewController
//--------------------------------------------------------------------------------------------------------
@synthesize textfieldsView;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"AddNewGalleryViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
		
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
	[self.navigationController.navigationBar setHidden:NO];
}
//--------------------------------------------------------------------------------------------------------

-(IBAction)cancelSave{
	[self dismissModalViewControllerAnimated:YES];
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[self scrollViewTo:textField movePixels:88 baseView:textfieldsView];
  	return YES;
}
//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillHide: (NSNotification *) notification {	
	[self scrollViewTo:nil movePixels:0 baseView:textfieldsView];
}
@end
