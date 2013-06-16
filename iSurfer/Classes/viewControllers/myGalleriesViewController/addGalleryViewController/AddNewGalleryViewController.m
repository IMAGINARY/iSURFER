//
//  AddNewGalleryViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddNewGalleryViewController.h"
#import "Gallery.h"

@implementation AddNewGalleryViewController
//--------------------------------------------------------------------------------------------------------
@synthesize textfieldsView, galleryName, galleryDescription, navBar, saveButton;
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
	navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	[self.navigationController.navigationBar setHidden:NO];
}
//--------------------------------------------------------------------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	UIBarButtonItem *donePickerButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered  target:self action:@selector(nextAction)];
	self.navBar.rightBarButtonItem = donePickerButton;
	[donePickerButton release];
	[self scrollViewTo:textField movePixels:88 baseView:textfieldsView];
  	return YES;
}
//--------------------------------------------------------------------------------------------------------

-(void)nextAction{
	if( [galleryName isFirstResponder]){
		[galleryDescription becomeFirstResponder];
	}else{
		[galleryDescription resignFirstResponder];
	}
}
//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillHide: (NSNotification *) notification {	
	self.navBar.rightBarButtonItem = saveButton;
	[self scrollViewTo:nil movePixels:0 baseView:textfieldsView];
}
//--------------------------------------------------------------------------------------------------------

-(IBAction)cancelSave{
	[self dismissModalViewControllerAnimated:YES];
}

//--------------------------------------------------------------------------------------------------------
-(NSString*)fieldsAreValid{
	NSString* msg = NULL;
	if( [galleryName.text isEqualToString:@""] ){
		msg =  @"You must enter a Gallery name!";
	}else if ([galleryDescription.text isEqualToString:@""]){
		msg = @"You must enter a Gallery description";	
	}
	return msg;
}

//--------------------------------------------------------------------------------------------------------
-(IBAction)addGallery{
	NSString* error = [self fieldsAreValid];
	if( error ){
		UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:@"Save" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[validationAlert show];
		[validationAlert release];
	}else{
		Gallery* newGallery = [[Gallery alloc]init];
		[newGallery setGalleryName:self.galleryName.text];
		[newGallery setGalleryDescription:self.galleryDescription.text];
		newGallery.editable = YES;
		newGallery.thumbNail = NULL;
		[self.appcontroller addGallery:newGallery atIndex:[appcontroller getGalleriesCount]];
		[newGallery release];
		[self dismissModalViewControllerAnimated:YES];
	}
}

//--------------------------------------------------------------------------------------------------------
-(void)dealloc{
	[saveButton release];
	[navBar release];
	[galleryDescription release];
	[galleryName release];
	[textfieldsView release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------

@end
