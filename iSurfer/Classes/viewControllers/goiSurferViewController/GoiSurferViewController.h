//
//  GoiSurferViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface GoiSurferViewController : BaseViewController <UITextFieldDelegate>{
	NSMutableArray* optionsViews;
	
	//main view
	IBOutlet UIView* baseView;
	//equation Textfield
	IBOutlet UITextField* equationTextField;
	IBOutlet UIView* equationTextfieldView;
	IBOutlet UIView* keyboardExtensionBar;
	
	// share view outlets
	IBOutlet UIView* shareView;
	
	//Color palette view outlets
	IBOutlet UIView* colorPaletteView;
	IBOutlet UIView* colorTestView;
	IBOutlet UISlider* greenColorSlider;
	IBOutlet UISlider* blueColorSlider;
	IBOutlet UISlider* redColorSlider;
	
	IBOutlet UIView* algebraicSurfaceView;

}
@property(nonatomic, retain)	IBOutlet UIView* equationTextfieldView;



@property(nonatomic, retain)	IBOutlet UIView* algebraicSurfaceView;


@property(nonatomic, retain)	IBOutlet UISlider* greenColorSlider;

@property(nonatomic, retain)	IBOutlet UISlider* blueColorSlider;
@property(nonatomic, retain)	IBOutlet UISlider* redColorSlider;


@property(nonatomic, retain)	IBOutlet UIView* colorTestView;
@property(nonatomic, retain)	NSMutableArray* optionsViews;


@property(nonatomic, retain)	IBOutlet UIView* colorPaletteView;
@property(nonatomic, retain)	IBOutlet UIView* shareView;

@property(nonatomic, retain)	IBOutlet UIView* baseView;
@property(nonatomic, retain)	IBOutlet UITextField* equationTextField;
@property(nonatomic, retain)	IBOutlet UIView* keyboardExtensionBar;

-(IBAction)keyboardBarButtonPressed:(id)sender;
-(IBAction)optionsButtonPressed:(id)sender;
-(IBAction)hideOptions:(id)sender;

- (IBAction)sliderChanged:(id)sender;

@end
