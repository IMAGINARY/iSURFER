//
//  SaveAlgebraicSurfaceViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
@class GoiSurferViewController;
@interface SaveAlgebraicSurfaceViewController : BaseViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>{
	IBOutlet UIPickerView* galleryPicker;
	IBOutlet UITextField* surfaceNameTextfield;
	IBOutlet UITextView* surfaceDescriptionTextView;
	IBOutlet UIButton* galleriesPickerButton;
	IBOutlet UILabel* galleryNameLabel;
	IBOutlet UIView* pickerWrapperView;	
	IBOutlet UIView* dataWrapperView;
	
	IBOutlet UIBarButtonItem* saveButton;
	IBOutlet UINavigationItem* navBar;
	
	IBOutlet UINavigationBar* navigationBar;
	int galleryIndex;
    
    GoiSurferViewController* delegate;
    
    NSMutableArray* editableGalleries;
	
}
@property(nonatomic, retain)IBOutlet UINavigationItem* navBar;


@property(nonatomic, retain)IBOutlet UIBarButtonItem* saveButton;

@property(nonatomic, assign)IBOutlet     GoiSurferViewController* delegate;


@property(nonatomic, retain)IBOutlet UIView* dataWrapperView;
@property(nonatomic, retain)IBOutlet UIView* pickerWrapperView;
@property(nonatomic, retain)IBOutlet UILabel* galleryNameLabel;
@property(nonatomic, retain)IBOutlet UIButton* galleriesPickerButton;
@property(nonatomic, retain)IBOutlet UIPickerView* galleryPicker;
@property(nonatomic, retain)IBOutlet UITextField* surfaceNameTextfield;
@property(nonatomic, retain)IBOutlet UITextView* surfaceDescriptionTextView;

-(id) initWithAppController:(AppController*)anappCtrl;
-(IBAction)showGalleriiesPicker:(BOOL)yes;
-(IBAction)done;
-(IBAction)saveSurface;
-(IBAction)cancel;


@end
