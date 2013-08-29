//
//  GoiSurferViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoadingView.h"
#import "FCColorPickerViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@class iSurferViewController;
@class EAGLView;
@class FCColorPickerViewController;
@interface GoiSurferViewController : BaseViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, ColorPickerViewControllerDelegate>{
	NSMutableArray* optionsViews;
	//main view
	IBOutlet UIView* baseView;
	//equation Textfield
	IBOutlet UITextField* equationTextField;
	IBOutlet UIView* equationTextfieldView;
	IBOutlet UIView* keyboardExtensionBar;
    int COUNTER;
	
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
	
    IBOutlet UIButton* colorButton;
    IBOutlet UIButton* shareButton;
    IBOutlet UIButton* saveButton;
    IBOutlet UIButton* settingsButton;
    IBOutlet UIButton* galleriesButton;
    IBOutlet UIButton* helpButton;

    IBOutlet UILabel* showBondingLabel;
    IBOutlet UILabel* coneLabel;
    IBOutlet UILabel* sphereLabel;
    IBOutlet UILabel* torusLabel;
    IBOutlet UILabel* knotLabel;
    IBOutlet UILabel* bottleLabel;
    IBOutlet UILabel* mobiusLabel;
    IBOutlet UILabel* changeLightsLabel;
    IBOutlet UILabel* toonShaderLabel;
    IBOutlet UILabel* blackBackgroundLabel;
	
	//Zoom view
	IBOutlet UIView* zoomView;
	UISlider* zoomSlider;
	
	BOOL fullScreen;
	CGRect algebraicsurfaceViewFrame;
	BOOL showZoomSlider;
	float previousScale;
	AlgebraicSurface* algebraicSurface;
	
	
	iSurferViewController* openglController;

	IBOutlet UIImageView* temporalimgView;
    
    NSArray* keyboardButtons;
    NSString* currentEquation;
    
    LoadingView * lv;

    FCColorPickerViewController* colorpalette;
    
    SLComposeViewController *mySLComposerSheet;

}

@property(nonatomic, retain)	AlgebraicSurface* algebraicSurface;


@property(nonatomic, retain)	IBOutlet UIView* zoomView;
@property(nonatomic, retain)	UISlider* zoomSlider;
@property(nonatomic, retain)    IBOutlet UIButton* colorButton;
@property(nonatomic, retain)    IBOutlet UIButton* shareButton;
@property(nonatomic, retain)	IBOutlet UIButton* saveButton;
@property(nonatomic, retain)    IBOutlet UIButton* settingsButton;
@property(nonatomic, retain)    IBOutlet UIButton* galleriesButton;
@property(nonatomic, retain)    IBOutlet UIButton* helpButton;
@property(nonatomic, retain)	IBOutlet UIImageView* rotateimage;
@property(nonatomic, retain)	IBOutlet UIView* equationTextfieldView;
@property(nonatomic, retain)	IBOutlet EAGLView* algebraicSurfaceView;
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

@property(nonatomic, retain)    IBOutlet UILabel* showBondingLabel;
@property(nonatomic, retain)    IBOutlet UILabel* coneLabel;
@property(nonatomic, retain)    IBOutlet UILabel* sphereLabel;
@property(nonatomic, retain)    IBOutlet UILabel* torusLabel;
@property(nonatomic, retain)    IBOutlet UILabel* knotLabel;
@property(nonatomic, retain)    IBOutlet UILabel* bottleLabel;
@property(nonatomic, retain)    IBOutlet UILabel* mobiusLabel;
@property(nonatomic, retain)    IBOutlet UILabel* changeLightsLabel;
@property(nonatomic, retain)    IBOutlet UILabel* toonShaderLabel;
@property(nonatomic, retain)    IBOutlet UILabel* blackBackgroundLabel;

@property(nonatomic, retain) UIColor* color1;
@property(nonatomic, retain) UIColor* color2;
@property(nonatomic, assign)BOOL shouldCompileSurface;

-(id) initWithAppController:(AppController*)anappCtrl andAlgebraicSurface:(AlgebraicSurface*)surface;


-(IBAction)keyboardBarButtonPressed:(id)sender;
-(IBAction)keyboardBarHyppenMinusButtonPressed:(id)sender;
-(IBAction)keyboardBarMinusButtonPressed:(id)sender;

-(IBAction)optionsButtonPressed:(id)sender;
-(IBAction)hideOptions:(id)sender;
-(IBAction)saveImage;
-(UIImage*)getSurfaceImage;
-(IBAction)flipToGalleries:(id)sender;
-(void)setSurfaceImg;
-(void)removeColorPalette;
-(void)setSurfaceImg;

-(void)doGenerateSurface:(NSString*)eqText;

@end
