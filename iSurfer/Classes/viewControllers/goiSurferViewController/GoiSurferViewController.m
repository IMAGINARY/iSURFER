//
//  GoiSurferViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoiSurferViewController.h"

//--------------------------------------------------------------------------------------------------------
@implementation GoiSurferViewController
//--------------------------------------------------------------------------------------------------------
@synthesize equationTextField;

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"GoiSurferViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	return YES;
}
//--------------------------------------------------------------------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[equationTextField resignFirstResponder];
	return YES;
}
//--------------------------------------------------------------------------------------------------------

-(void)doneButtonPressed{
	[equationTextField resignFirstResponder];
	//aca habria que hacer todo el parseo y validarlo
 }
//--------------------------------------------------------------------------------------------------------

- (void) keyboardDidShow: (NSNotification *) notification {	
	NSLog(@"keyboarddidshow");
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 123, 158,39); 

    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setImage:[UIImage imageNamed:@"doneup.png"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"donedown.png"] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
	
	NSString *keyboardPrefix = [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2 ? @"<UIPeripheralHost" : @"<UIKeyboard";
	NSLog(@"%@", keyboardPrefix);
	NSArray *allWindows = [[UIApplication sharedApplication] windows];
	int topWindow = [allWindows count] - 1;
	UIWindow *keyboardWindow = [allWindows objectAtIndex:topWindow];
	for (UIView *subView in keyboardWindow.subviews) {
        if ([[subView description] hasPrefix:keyboardPrefix]) {
            [subView addSubview:doneButton];
			[subView bringSubviewToFront:doneButton];
            break;
        }
    }
}
//--------------------------------------------------------------------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[self scrollViewTo:equationTextField movePixels:80];
  	return YES;
}


//--------------------------------------------------------------------------------------------------------
-(void)dealloc{
	[super dealloc];
	[equationTextField release];
}

//--------------------------------------------------------------------------------------------------------


@end
