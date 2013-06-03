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
    IBOutlet UILabel* surfaceNameLabel;
    IBOutlet UILabel* surfaceDescriptionLabel;
    IBOutlet UILabel* galleryLabel;
    
    
	IBOutlet UIPickerView* galleryPicker;
	IBOutlet UITextField* surfaceNameTextfield;
	IBOutlet UITextView* surfaceDescriptionTextView;
    IBOutlet UIButton* galleryCreateButton;
	IBOutlet UIButton* galleriesPickerButton;
    IBOutlet UIImageView * blackLine;
	IBOutlet UILabel* galleryNameLabel;
	IBOutlet UIView* pickerWrapperView;	
	IBOutlet UIView* dataWrapperView;
	
	IBOutlet UIBarButtonItem* saveButton;
    IBOutlet UIBarButtonItem* cancelButton;
	IBOutlet UINavigationItem* navBar;
	
	IBOutlet UINavigationBar* navigationBar;
	int galleryIndex;
    
    GoiSurferViewController* delegate;
    
    NSMutableArray* editableGalleries;
	
}
@property(nonatomic, retain)IBOutlet UINavigationItem* navBar;


@property(nonatomic, retain)IBOutlet UIBarButtonItem* saveButton;
@property(nonatomic, retain)IBOutlet UIBarButtonItem* cancelButton;

@property(nonatomic, assign)IBOutlet     GoiSurferViewController* delegate;

@property(nonatomic, assign)IBOutlet UILabel* surfaceNameLabel;
@property(nonatomic, assign)IBOutlet UILabel* surfaceDescriptionLabel;
@property(nonatomic, assign)IBOutlet UILabel* galleryLabel;


@property(nonatomic, retain)IBOutlet UIView* dataWrapperView;
@property(nonatomic, retain)IBOutlet UIView* pickerWrapperView;
@property(nonatomic, retain)IBOutlet UILabel* galleryNameLabel;
@property(nonatomic, retain)IBOutlet UIButton* galleriesPickerButton;
@property(nonatomic, retain)IBOutlet UIImageView* blackLine;
@property(nonatomic, retain)IBOutlet UIButton* galleryCreateButton;
@property(nonatomic, retain)IBOutlet UIPickerView* galleryPicker;
@property(nonatomic, retain)IBOutlet UITextField* surfaceNameTextfield;
@property(nonatomic, retain)IBOutlet UITextView* surfaceDescriptionTextView;

-(id) initWithAppController:(AppController*)anappCtrl;
-(IBAction)showGalleriiesPicker:(BOOL)yes;
-(IBAction)done;
-(IBAction)saveSurface;
-(IBAction)cancel;


@end
