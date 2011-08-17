//
//  SaveAlgebraicSurfaceViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaveAlgebraicSurfaceViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SaveAlgebraicSurfaceViewController
//--------------------------------------------------------------------------------------------------------
@synthesize galleryPicker, surfaceNameTextfield, surfaceDescriptionTextView, galleriesPickerButton, galleryNameLabel, pickerWrapperView, dataWrapperView, saveButton, navBar;
//--------------------------------------------------------------------------------------------------------
-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"SaveAlgebraicSurfaceViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.galleryNameLabel.text = @"";
	self.surfaceDescriptionTextView.text = @"";
	self.galleryNameLabel.text = @"";
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[surfaceDescriptionTextView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [surfaceDescriptionTextView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [surfaceDescriptionTextView.layer setBorderWidth: 1.0];
    [surfaceDescriptionTextView.layer setCornerRadius:8.0f];
    [surfaceDescriptionTextView.layer setMasksToBounds:YES];
	[super viewDidLoad];
}
//--------------------------------------------------------------------------------------------------------

-(NSString*)fieldsAreValid{
	
	NSString* msg = NULL;
	if( [surfaceNameTextfield.text isEqualToString:@""] ){
		msg =  @"You must enter a surface name!";
	}else if ([surfaceDescriptionTextView.text isEqualToString:@""]){
		msg = @"You must enter a surface description";	
	}else if ([galleryNameLabel.text isEqualToString:@""]){
		msg = @"You must choose a gallery";	
	}
	return msg;
}
//--------------------------------------------------------------------------------------------------------

-(IBAction)saveSurface{
	NSString* error = [self fieldsAreValid];
	if( error ){
		UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:@"Save" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[validationAlert show];
		[validationAlert release];
	}
	else{
		AlgebraicSurface* newSurface = [[AlgebraicSurface alloc] init];
		[newSurface setSurfaceName:self.galleryNameLabel.text];
		[newSurface setSurfaceDescription:self.surfaceDescriptionTextView.text];
		[appcontroller addAlgebraicSurface:newSurface atGalleryIndex:galleryIndex];
		[newSurface release];
		
		[self dismissModalViewControllerAnimated:YES];
	}
}
//--------------------------------------------------------------------------------------------------------

-(IBAction)cancel{
	[self dismissModalViewControllerAnimated:YES];
}
//--------------------------------------------------------------------------------------------------------
-(IBAction)done{
	[self showGalleriiesPicker:NO];
	[self scrollViewTo:nil movePixels:0 baseView:self.dataWrapperView];
}
//--------------------------------------------------------------------------------------------------------
-(IBAction)showGalleriiesPicker:(BOOL)yes{
	CGRect r=[pickerWrapperView frame];
	if(yes){
		r.origin.y =  SHOW_GALLERIES_PICKER;
		UIBarButtonItem *donePickerButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered  target:self action:@selector(hidePicker)];
		self.navBar.rightBarButtonItem = donePickerButton;
		[donePickerButton release];
		[self scrollViewTo:galleriesPickerButton movePixels:55 baseView:self.dataWrapperView];
	}else{
		r.origin.y = HIDE_GALLERIES_PICKER;
		self.navBar.rightBarButtonItem = saveButton;
		[self scrollViewTo:nil movePixels:0 baseView:self.dataWrapperView];
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[pickerWrapperView setFrame:r];
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------
-(void)hidePicker{
	[self showGalleriiesPicker:NO];
}
//--------------------------------------------------------------------------------------------------------

-(void)nextEdittingField{
	if( [surfaceNameTextfield isFirstResponder] ){
		[surfaceDescriptionTextView becomeFirstResponder];
	}else if( [surfaceDescriptionTextView isFirstResponder] ){
		[surfaceDescriptionTextView resignFirstResponder];
		[self showGalleriiesPicker:YES];
	}
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[surfaceNameTextfield release];
	[surfaceDescriptionTextView release];
	[galleryPicker release];
	[galleriesPickerButton release];
	[galleryNameLabel release];
	[pickerWrapperView release];
	[dataWrapperView release];
	[saveButton release];
	[navBar release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [[appcontroller getGallery:row]galleryName];
}
//--------------------------------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	galleryIndex = row;
	self.galleryNameLabel.text = [[appcontroller getGallery:row]galleryName];
}
//--------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [appcontroller getGalleriesCount];
}
//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillHide: (NSNotification *) notification {	
	self.navBar.rightBarButtonItem = saveButton;
	[self scrollViewTo:nil movePixels:0 baseView:self.dataWrapperView];
}

//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillShow: (NSNotification *) notification {	
	UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextEdittingField)];
	self.navBar.rightBarButtonItem = nextButton;
	[nextButton release];
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[self scrollViewTo:textField movePixels:85 baseView:self.dataWrapperView];
  	return YES;
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
	[self scrollViewTo:textView movePixels:47 baseView:self.dataWrapperView];
	return YES;
}
//--------------------------------------------------------------------------------------------------------

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
	[surfaceDescriptionTextView resignFirstResponder];
	return YES;
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
		return NO;
    }
    return YES;
}
//--------------------------------------------------------------------------------------------------------

@end
