//
//  GoiSurferViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@class iSurferViewController;
@class EAGLView;
@interface GoiSurferViewController : BaseViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>{
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
    IBOutlet UIView* settingsView;
	IBOutlet UIView* colorPaletteView;
	IBOutlet UIView* colorTestView;
	IBOutlet UISlider* greenColorSlider;
	IBOutlet UISlider* blueColorSlider;
	IBOutlet UISlider* redColorSlider;
	
	IBOutlet EAGLView* algebraicSurfaceView;
	
	IBOutlet UIImageView* rotateimage;
	
	IBOutlet UIButton* saveButton;
	
	//Zoom view
	IBOutlet UIView* zoomView;
	UISlider* zoomSlider;
	
	
	BOOL fullScreen;
	CGRect algebraicsurfaceViewFrame;
	BOOL showZoomSlider;
	float previousScale;
	
	AlgebraicSurface* algebraicSurface;
	
	IBOutlet UILabel* xpos;
	IBOutlet UILabel* ypos;
	
	iSurferViewController* openglController;

	IBOutlet UIImageView* temporalimgView;
    
    NSArray* keyboardButtons;

}

@property(nonatomic, retain)	AlgebraicSurface* algebraicSurface;


@property(nonatomic, retain)	IBOutlet UIView* zoomView;
@property(nonatomic, retain)	 UISlider* zoomSlider;
@property(nonatomic, retain)	IBOutlet UIButton* saveButton;
@property(nonatomic, retain)	IBOutlet UIImageView* rotateimage;
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
@property(nonatomic, retain)	IBOutlet UIImageView* temporalimgView;


-(id) initWithAppController:(AppController*)anappCtrl andAlgebraicSurface:(AlgebraicSurface*)surface;


-(IBAction)keyboardBarButtonPressed:(id)sender;
-(IBAction)keyboardBarHyppenMinusButtonPressed:(id)sender;
-(IBAction)keyboardBarMinusButtonPressed:(id)sender;

-(IBAction)optionsButtonPressed:(id)sender;
-(IBAction)hideOptions:(id)sender;
-(IBAction)sliderChanged:(id)sender;
-(IBAction)saveImage;
-(IBAction)setSurfaceColors;
-(UIImage*)getSurfaceImage;
-(IBAction)flipToGalleries:(id)sender;

@end
