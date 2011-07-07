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
@synthesize equationTextField, keyboardExtensionBar, baseView;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"GoiSurferViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.view setFrame:CGRectMake(0, 0, 480, 370)];
}

//--------------------------------------------------------------------------------------------------------
-(IBAction)keyboardBarButtonPressed:(id)sender{
	UIButton* button = (UIButton*)sender;
	NSLog(@"%@", button.titleLabel.text);
	self.equationTextField.text = [equationTextField.text stringByAppendingString:button.titleLabel.text];
}
//--------------------------------------------------------------------------------------------------------

-(void)doneButtonPressed{
	[equationTextField resignFirstResponder];
	//aca habria que hacer todo el parseo y validarlo
 }
#pragma mark Keyboard methods

//--------------------------------------------------------------------------------------------------------
-(void)showExtKeyboard:(BOOL)yesOrNo {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect r=[keyboardExtensionBar frame];
	if(yesOrNo){
		r.origin.y=  KEYBOARD_VIEW_SHOW_HEIGHT;
	}else{
		r.origin.y= KEYBOARD_VIEW_HIDE_HEIGHT;
	}
	[keyboardExtensionBar setFrame:r];
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillHide: (NSNotification *) notification {
	[self scrollViewTo:nil movePixels:0 baseView:self.baseView];
	[self showExtKeyboard:NO];
}
//---------------------------------------------------------------------------------------------
- (void) keyboardWillShow: (NSNotification *) notification {	
	[self showExtKeyboard:YES];
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
			NSLog(@"x: %f  y: %f  width: %f  height: %f", subView.frame.origin.x, subView.frame.origin.y, subView.frame.size.width, subView.frame.size.height);
            [subView addSubview:doneButton];
			[subView bringSubviewToFront:doneButton];
            break;
        }
    }
}
#pragma mark UITextfield delegate
//--------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[self scrollViewTo:equationTextField movePixels:55 baseView:self.baseView];
  	return YES;
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[equationTextField resignFirstResponder];
	return YES;
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	return YES;
}
//--------------------------------------------------------------------------------------------------------
#pragma mark dealloc

-(void)dealloc{
	[super dealloc];
	[equationTextField release];
	[keyboardExtensionBar release];
	[baseView release];
}
//---------------------------------------------------------------------------------------------
@end
