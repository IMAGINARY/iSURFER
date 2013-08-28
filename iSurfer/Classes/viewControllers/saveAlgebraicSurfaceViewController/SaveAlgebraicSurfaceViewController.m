//
//  SaveAlgebraicSurfaceViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaveAlgebraicSurfaceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GoiSurferViewController.h"
#import "AddNewGalleryViewController.h"

@implementation SaveAlgebraicSurfaceViewController
//--------------------------------------------------------------------------------------------------------
@synthesize galleryPicker, surfaceNameTextfield, surfaceDescriptionTextView, galleriesPickerButton, galleryNameLabel, blackLine, galleryCreateButton, pickerWrapperView, dataWrapperView, saveButton, cancelButton, navBar, delegate, surfaceNameLabel, galleryLabel, surfaceDescriptionLabel, image;
//--------------------------------------------------------------------------------------------------------
-(id) initWithAppController:(AppController*)anappCtrl andImage: (UIImage*) surfaceImage{
	
	if (self = [super initWithNibName:@"SaveAlgebraicSurfaceViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
        
    surfaceImagex = surfaceImage;
    
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.galleryNameLabel.text = @"";
    editableGalleries = [[appcontroller getEditableGalleries]retain];
    if ([editableGalleries count] == 0) {
        galleriesPickerButton.hidden = true;
        blackLine.hidden = true;
    } else {
        galleriesPickerButton.hidden = false;
        blackLine.hidden = false;
    }
    [galleryPicker reloadAllComponents];
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
    self.image.image = surfaceImagex;
    
	navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
	[surfaceDescriptionTextView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [surfaceDescriptionTextView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [surfaceDescriptionTextView.layer setBorderWidth: 1.0];
    [surfaceDescriptionTextView.layer setCornerRadius:8.0f];
    [surfaceDescriptionTextView.layer setMasksToBounds:YES];
    [galleryCreateButton addTarget:self action:@selector(addGallery) forControlEvents:UIControlEventTouchUpInside];
    [self localize];
    
	[super viewDidLoad];
}

-(void)localize{
    [navBar setTitle:NSLocalizedString(@"SAVE_SURFACE", nil)];
    [surfaceNameLabel setText:NSLocalizedString(@"SURFACE_NAME", nil)];
    [surfaceDescriptionLabel setText:NSLocalizedString(@"SURFACE_DESCRIPTION", nil)];
    [galleryLabel setText:NSLocalizedString(@"GALLERY", nil)];
    [galleryCreateButton setTitle: NSLocalizedString(@"CREATE_GALLERY", nil) forState:UIControlStateNormal];
    [galleriesPickerButton setTitle: NSLocalizedString(@"CHOOSE_GALLERY", nil) forState:UIControlStateNormal];
    [saveButton setTitle:NSLocalizedString(@"SAVE", nil)];
    [cancelButton setTitle:NSLocalizedString(@"CANCEL", nil)];
}
//--------------------------------------------------------------------------------------------------------

-(NSString*)fieldsAreValid{
	
	NSString* msg = NULL;
	if( [surfaceNameTextfield.text isEqualToString:@""] ){
		msg =  NSLocalizedString(@"ERROR_SURFACE_NAME", nil);
	}else if ([surfaceDescriptionTextView.text isEqualToString:@""]){
		msg = NSLocalizedString(@"ERROR_SURFACE_DESCRIPTION", nil);
	}else if ([galleryNameLabel.text isEqualToString:@""]){
		msg = NSLocalizedString(@"ERROR_CHOOSE_GALLERY", nil);;	
	}
	return msg;
}
//--------------------------------------------------------------------------------------------------------

-(IBAction)saveSurface{
	NSString* error = [self fieldsAreValid];
	if( error ){
		UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"SAVE", nil) message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[validationAlert show];
		[validationAlert release];
	}
	else{
		AlgebraicSurface* newSurface = [[AlgebraicSurface alloc] init];
        newSurface.equation = @"x^2";
        newSurface.surfaceImage = surfaceImagex;
        Gallery * selectedGallery = [editableGalleries objectAtIndex:galleryIndex];
        newSurface.realImageName = [NSString stringWithFormat:@"/surface-images/%@%@%@%@", selectedGallery.galleryName, @"/", self.surfaceNameTextfield.text, @".png"];
        testimg.image = newSurface.surfaceImage;
		[newSurface setSurfaceName:self.surfaceNameTextfield.text];
		[newSurface setBriefDescription:self.surfaceDescriptionTextView.text];
        [newSurface setEquation:delegate.equationTextField.text];
		[appcontroller addAlgebraicSurface:newSurface atGallery:selectedGallery];
		[newSurface release];
        
/*        -(void)saveImage:(UIImage*)image withName:(NSString*)imagename{
            if( image != NULL ){
                NSData *pngData = UIImagePNGRepresentation(image);
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                NSString *filePath = [documentsPath stringByAppendingPathComponent:imagename]; //Add the file name
                [pngData writeToFile:filePath atomically:YES]; //Write the file
            }
        }*/
        
        
/*        -(UIImage*)loadImageFromFile:(NSString*)imagefileName{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:imagefileName]; //Add the file name
        return [[UIImage alloc] initWithContentsOfFile:filePath];
    }*/
        

		
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
        if( [appcontroller getGalleriesCount] > 0 ){
            r.origin.y =  SHOW_GALLERIES_PICKER;
            UIBarButtonItem *donePickerButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered  target:self action:@selector(hidePicker)];
            self.navBar.rightBarButtonItem = donePickerButton;
            [donePickerButton release];
            [self scrollViewTo:galleriesPickerButton movePixels:55 baseView:self.dataWrapperView];
        }else{
            UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:@"Galleries" message:@"You should create an editable gallery before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [validationAlert show];
            [validationAlert release];
        }
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
        if(editableGalleries.count != 0) {
            [self showGalleriiesPicker:YES];
        }
	}
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[surfaceNameTextfield release];
	[surfaceDescriptionTextView release];
	[galleryPicker release];
	[galleriesPickerButton release];
	[galleryNameLabel release];
    [blackLine release];
    [galleryCreateButton release];
	[pickerWrapperView release];
	[dataWrapperView release];
	[saveButton release];
	[navBar release];
    [editableGalleries release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if( [editableGalleries objectAtIndex:row] )
        return [[editableGalleries objectAtIndex:row]galleryName];
    else 
        return @"";
}
//--------------------------------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	galleryIndex = row;
	self.galleryNameLabel.text = [[editableGalleries objectAtIndex:row]galleryName];
    [galleriesPickerButton setTitle:@"" forState:(UIControlStateNormal)];
}
//--------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [editableGalleries count];
}
//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillHide: (NSNotification *) notification {	
	self.navBar.rightBarButtonItem = saveButton;
	[self scrollViewTo:nil movePixels:0 baseView:self.dataWrapperView];
}

//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillShow: (NSNotification *) notification {	
	UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"NEXT", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextEdittingField)];
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
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 104) ? NO : YES;
}
//--------------------------------------------------------------------------------------------------------

-(void)addGallery{
	AddNewGalleryViewController * addGallery = [[AddNewGalleryViewController alloc]initWithAppController:self.appcontroller];
	[self presentModalViewController:addGallery animated:YES];
	[addGallery release];
}

@end
