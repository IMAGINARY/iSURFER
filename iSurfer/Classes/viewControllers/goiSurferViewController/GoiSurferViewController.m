//
//  GoiSurferViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoiSurferViewController.h"
//--------------------------------------------------------------------------------------------------------
@interface GoiSurferViewController(PrivateMethods)
-(void)showOptionsViewWrapper:(BOOL)yes view:(UIView*)showingView;
@end
//--------------------------------------------------------------------------------------------------------
@implementation GoiSurferViewController
//--------------------------------------------------------------------------------------------------------
@synthesize equationTextField, keyboardExtensionBar, baseView, colorPaletteView, shareView, optionsViews, colorTestView, greenColorSlider, redColorSlider, blueColorSlider;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"GoiSurferViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
		optionsViews = [[NSMutableArray alloc]init];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
	[optionsViews addObject:self.shareView];
	[optionsViews addObject:self.colorPaletteView];
	[self.shareView setHidden:YES];
	[self.colorPaletteView setHidden:YES];
	self.greenColorSlider.minimumValue = 0;
	self.greenColorSlider.maximumValue = 255;

	self.redColorSlider.minimumValue = 0;
	self.redColorSlider.maximumValue = 255;

	self.blueColorSlider.minimumValue = 0;
	self.blueColorSlider.maximumValue = 255;
	UIColor* color = [UIColor colorWithRed:self.redColorSlider.value green:self.greenColorSlider.value blue:self.blueColorSlider.value alpha:1.0];
	[self.colorTestView setBackgroundColor:color];
}
//--------------------------------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}
//--------------------------------------------------------------------------------------------------------

-(void)viewWillDisappear:(BOOL)animated{
	for( UIView* optionView in self.optionsViews ){
		[optionView setHidden:YES];
	}
	[super viewWillDisappear:animated];
}

#pragma mark buttons actions
//--------------------------------------------------------------------------------------------------------
- (IBAction)sliderChanged:(id)sender { 
	UISlider *slider = (UISlider *)sender;
	switch (slider.tag) {
		case 1:
			self.redColorSlider.value +=1;
			break;
		case 2:
			self.greenColorSlider.value +=1;
			break;
		case 3:
			self.blueColorSlider.value +=1;
			break;
		default:
			break;
	}
	NSLog(@"red: %d  green : %f  blue: %f", redColorSlider.value, greenColorSlider.value, blueColorSlider.value );
	UIColor* color = [UIColor colorWithRed:(int)self.redColorSlider.value/255.0 green:(int)self.greenColorSlider.value /255.0 blue:(int)self.blueColorSlider.value/255.0 alpha:1.0];
	[self.colorTestView setBackgroundColor:color];
}
//--------------------------------------------------------------------------------------------------------
-(IBAction)optionsButtonPressed:(id)sender{
	UIButton* button = (UIButton*)sender;
	switch (button.tag) {
		case 1:
			[self showOptionsViewWrapper:YES view:shareView];
			break;
		case 2:
			[self showOptionsViewWrapper:YES view:colorPaletteView];
			break;
		default:
			break;
	}
}
//--------------------------------------------------------------------------------------------------------
-(IBAction)hideOptions:(id)sender{
	UIButton* backButton = (UIButton*)sender;
	[self showOptionsViewWrapper:NO view:backButton.superview];
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

-(void)showOptionsView:(BOOL)yes view:(UIView*)showingView{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect r=[showingView frame];
	if(yes){
		r.origin.x =  0;
	}else{
		r.origin.x = -OPTIONS_VIEWS_WIDTH;
	}
	[showingView setFrame:r];
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------

-(void)showOptionsViewWrapper:(BOOL)yes view:(UIView*)showingView{
	for( UIView* optionsView in self.optionsViews ){
		[self showOptionsView:NO view:optionsView];
	}
	if( showingView ){
		[showingView setHidden:NO];
		[self showOptionsView:yes view:showingView];
	}
}
//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillHide: (NSNotification *) notification {
	[self scrollViewTo:nil movePixels:0 baseView:self.baseView];
	[self showExtKeyboard:NO];
}
//---------------------------------------------------------------------------------------------
- (void) keyboardWillShow: (NSNotification *) notification {	
	[self showOptionsViewWrapper:NO view:nil];
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
	[equationTextField release];
	[keyboardExtensionBar release];
	[baseView release];
	[colorPaletteView release];
	[shareView release];
	[optionsViews release];
	[colorTestView release];
	[greenColorSlider release];
	[blueColorSlider release];
	[redColorSlider release];
	[super dealloc];
}
//---------------------------------------------------------------------------------------------
@end
