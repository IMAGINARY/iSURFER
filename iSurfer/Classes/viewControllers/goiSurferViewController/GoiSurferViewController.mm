//
//  GoiSurferViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoiSurferViewController.h"
#import "SaveAlgebraicSurfaceViewController.h"
#import "iSurferViewController.h"
#import "EAGLView.h"
#import "Interfaces.hpp"
#include "programData.hpp"
#import "GoiSurferViewController+Share.h"
#import "UITextField+removecharacters.h"

//#import "SVProgressHUD.h"
//--------------------------------------------------------------------------------------------------------
@interface GoiSurferViewController(PrivateMethods)
-(void)showOptionsViewWrapper:(BOOL)yes view:(UIView*)showingView;

@end
//--------------------------------------------------------------------------------------------------------
@implementation GoiSurferViewController
//--------------------------------------------------------------------------------------------------------
@synthesize equationTextField, keyboardExtensionBar, baseView, colorPaletteView, shareView, optionsViews, colorTestView, greenColorSlider, redColorSlider, blueColorSlider;
@synthesize algebraicSurfaceView, equationTextfieldView,rotateimage, colorButton, shareButton, saveButton, galleriesButton, settingsButton, helpButton, zoomSlider, zoomView, algebraicSurface, temporalimgView, showBondingLabel, coneLabel, sphereLabel, torusLabel, knotLabel, bottleLabel, mobiusLabel;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl andAlgebraicSurface:(AlgebraicSurface*)surface{
	
	if (self = [super initWithNibName:@"GoiSurferViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
		if (surface) {
			self.algebraicSurface = surface;
		}
		optionsViews = [[NSMutableArray alloc]init];
        COUNTER = 0;
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------
-(void)viewDidLoad{
    
	[super viewDidLoad];
    self.firstTimeInApp = YES;
    keyboardButtons = [[NSArray alloc]initWithObjects:@"x", @"y",@"z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7", @"8",@"9",@"+",@"-",@"*",@"^2",@"^3",@"^",@"(",@")",@",",@"",nil];
	//Color sliders conf
    
    [self localize];
    
    equationTextField.inputView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    
    colorpalette = [[FCColorPickerViewController alloc]initWithNibName:@"FCColorPickerViewController" bundle:[NSBundle mainBundle]];
    colorpalette.delegate = self;
    
    colorpalette.color =     [UIColor colorWithRed:programData::colorR green:programData::colorG blue:programData::colorB alpha:0.5];
    //[UIColor greenColor];
    colorpalette.view.frame = CGRectMake(0, 0, 430, 320 );
    
	[optionsViews addObject:self.shareView];
	[optionsViews addObject:colorpalette.view];
    [optionsViews addObject:settingsView];
    
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
	CALayer * layer = [algebraicSurfaceView layer];
	layer.cornerRadius = 8;
	CALayer * layer2 = [shareView layer];
	layer2.cornerRadius = 8;
	CALayer * layer3 = [colorPaletteView layer];
	layer3.cornerRadius = 8;
	
	//Zoom slider
	UISlider* tmpzoomSlider = [[UISlider alloc]init];
    CGRect zoomframe = CGRectMake(-115, 25,80, 35);
    tmpzoomSlider.frame = zoomframe;
	tmpzoomSlider.minimumValue = 1;
	tmpzoomSlider.maximumValue = 100;
	[tmpzoomSlider setUserInteractionEnabled:NO];
	CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI * 0.5);
    tmpzoomSlider.transform = trans;
	[self.zoomView addSubview:tmpzoomSlider];
	CGRect frame = tmpzoomSlider.frame;
	frame.origin.x = 5;
	frame.origin.y = 30;;
	frame.size.height = 150;
	[tmpzoomSlider setFrame:frame];
	[self setZoomSlider:tmpzoomSlider];
	[tmpzoomSlider release];
	
	//Gestures handler
	UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
	UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
	UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
	UILongPressGestureRecognizer* doubleTouch = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleTwoFingerTouch:)];
	UILongPressGestureRecognizer* singleLongPressTouch = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleLongPressTouch:)];
    
	[pinchGesture setDelegate:self];
	
	[singleLongPressTouch setMinimumPressDuration:0.08];
	
	[doubleTouch setDelegate:self];
	[doubleTouch setNumberOfTouchesRequired:2];
	[doubleTouch setMinimumPressDuration:0.0];
	
	[doubleTap setNumberOfTapsRequired:2];
	[doubleTap setDelegate:self];
	
	[panGesture setDelegate:self];
    
	[self.algebraicSurfaceView addGestureRecognizer:pinchGesture];
	[self.algebraicSurfaceView addGestureRecognizer:doubleTouch];
	[self.algebraicSurfaceView addGestureRecognizer:singleLongPressTouch];
	[self.algebraicSurfaceView addGestureRecognizer:doubleTap];
	[self.algebraicSurfaceView addGestureRecognizer:panGesture];
    
	[singleLongPressTouch release];
	[panGesture release];
	[doubleTouch release];
	[pinchGesture release];
	[doubleTap release];
	[self.zoomView setAlpha:0.0];
	
	
	algebraicsurfaceViewFrame = algebraicSurfaceView.frame;
    //   [self 	doOpenGLMagic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedDrewFrameNotif)
                                                 name:@"drewnotif"
                                               object:nil];
    
    
    
	[self performSelectorInBackground:@selector(doOpenGLMagic) withObject:nil];
}

- (void) localize{
    [colorButton setTitle: NSLocalizedString(@"MENU_COLOR", nil) forState:UIControlStateNormal];
    [shareButton setTitle:NSLocalizedString(@"MENU_SHARE", nil) forState:UIControlStateNormal];
    [saveButton setTitle:NSLocalizedString(@"MENU_SAVE", nil) forState:UIControlStateNormal];
    [galleriesButton setTitle:NSLocalizedString(@"MENU_GALLERIES", nil) forState:UIControlStateNormal];
    [settingsButton setTitle:NSLocalizedString(@"MENU_SETTINGS", nil) forState:UIControlStateNormal];
    [helpButton setTitle:NSLocalizedString(@"MENU_HELP", nil) forState:UIControlStateNormal];
    [showBondingLabel setText: NSLocalizedString(@"SHOW_BONDING", nil)];
    [coneLabel setText: NSLocalizedString(@"CONE", nil)];
    [torusLabel setText: NSLocalizedString(@"TORUS", nil)];
    [sphereLabel setText: NSLocalizedString(@"SPHERE", nil)];
    [knotLabel setText: NSLocalizedString(@"KNOT", nil)];
    [mobiusLabel setText: NSLocalizedString(@"MOBIUS", nil)];
    [bottleLabel setText: NSLocalizedString(@"BOTTLE", nil)];
}


-(void)receivedDrewFrameNotif{
    
    
}
//--------------------------------------------------------------------------------------------------------

-(void)doOpenGLMagic{
    lv = [LoadingView loadingView:@""];
    [self.view addSubview:lv];
    
	openglController = [[iSurferViewController alloc]init];
    openglController.delegate = self;
	openglController.view = algebraicSurfaceView;
	[openglController setupGLContxt];
    //	[openglController performSelectorInBackground:@selector(startAnimation) withObject:nil];]
	[openglController startAnimation];
    [self performSelectorOnMainThread:@selector(dismissRosquet) withObject:nil waitUntilDone:NO];
    [openglController drawFrame];
    
}

-(void)dismissRosquet{
    
    [self removeLoadingView];
    [self performSelector:@selector(setTemporalImage) withObject:nil afterDelay:0.5];
}

-(void)setTemporalImage{
    UIImage* image = [algebraicSurfaceView snapshot];
    //   temporalimgView.image = [algebraicSurfaceView snapshot];
    
}

//--------------------------------------------------------------------------------------------------------
-(void)handleSingleLongPressTouch:(UILongPressGestureRecognizer*)singleLongPressGesture{
	switch (singleLongPressGesture.state) {
		case UIGestureRecognizerStateBegan:
            
            break;
		case UIGestureRecognizerStateChanged:
			break;
		case UIGestureRecognizerStateEnded:
			[openglController drawFrame];
            break;
		default:
			break;
	}
}
//--------------------------------------------------------------------------------------------------------

-(void)changeframe{
    CGRect f;
    
    f = CGRectMake(0, 0, 90, 70	);
    algebraicSurfaceView.frame = f;
    
    temporalimgView.hidden = NO;
    NSLog(@"changeframe");
    
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)gestureRecognizer{
	CGPoint p;
	p = [gestureRecognizer locationInView:baseView]; //:gestureRecognizer.view];
    //p = [gestureRecognizer translationInView:gestureRecognizer.view];
    
	CGRect f;
	switch (gestureRecognizer.state) {
		case UIGestureRecognizerStateBegan:
			NSLog(@"began");
			//temporalimgView.image = [self captureView:algebraicSurfaceView];
            //      temporalimgView.image = [algebraicSurfaceView snapshot];
            
            //
            // UITouch* touch = [touches anyObject];
            // CGPoint previous  = [touch previousLocationInView: self];
            // CGPoint current = [touch locationInView: self];
            
            [openglController initRotationX:p.x Y:p.y];
            [self changeframe];
            //     [self performSelector:@selector(changeframe) withObject:nil afterDelay:0.1];
            
            
			break;
		case UIGestureRecognizerStateChanged:
            [openglController rotateX:p.x Y:p.y];
            
            //	temporalimgView.image = [self captureView:algebraicSurfaceView];
            //   temporalimgView.image =[self imageWithView:algebraicSurfaceView];
            //	temporalimgView.image = [openglController drawableToCGImage];
            //        temporalimgView.image = [algebraicSurfaceView snapUIImage];
            
            //      temporalimgView.image = [self captureView:algebraicSurfaceView];
            //     temporalimgView.image = [algebraicSurfaceView screenShotUIImage];
            //     temporalimgView.image = [algebraicSurfaceView drawableToCGImage];
            
            
            //            temporalimgView.image = [algebraicSurfaceView snapshot];
            
			break;
		case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
			[openglController endRotationX:p.x Y:p.y];
            NSLog(@"UIGestureRecognizerStateEnded");
            
            //			[openglController rotateX:p.x Y:p.y];
            if( fullScreen){
                f = CGRectMake(0, 0, 440, 320	);
            }else{
                f = CGRectMake(0, 0 , 400, 277	);
            }
			algebraicSurfaceView.frame = f;
            
			[openglController performSelector:@selector(drawFrame) withObject:nil afterDelay:0.1  ];
            [self performSelector:@selector(hidetempimage) withObject:nil afterDelay:0.4];
            
            
			break;
		default:
			break;
	}
}

//--------------------------------------------------------------------------------------------------------
-(void)hidetempimage{
    //    temporalimgView.image = [algebraicSurfaceView snapshot];
    
    //  temporalimgView.hidden = YES;
    
    
}
//-------------------------------------------------------------------------------------------------------

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if(([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] )||
       (  [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) ){
        return YES;
    }
    return NO;
}
//-------------------------------------------------------------------------------------------------------

-(UIImage*)getSurfaceImage{
    
    return [algebraicSurfaceView snapshot];
}
//-------------------------------------------------------------------------------------------------------


-(void)handleTwoFingerTouch:(UIGestureRecognizer*)doubleFingerGesture{
	switch (doubleFingerGesture.state) {
		case UIGestureRecognizerStateBegan:
			showZoomSlider = YES;
			break;
		case UIGestureRecognizerStateChanged:
			break;
		case UIGestureRecognizerStateEnded:
			showZoomSlider = NO;
			break;
		default:
			break;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	if(showZoomSlider){
		[self.zoomView setAlpha:1.0];
	}else{
		[self.zoomView setAlpha:0.0];
	}
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinchGesture{
	if( pinchGesture.state == UIGestureRecognizerStateBegan ){
		previousScale = pinchGesture.scale;
	}else if( pinchGesture.state == UIGestureRecognizerStateChanged ){
		if( previousScale > pinchGesture.scale ){
			self.zoomSlider.value -= 1;
		}else {
			self.zoomSlider.value += 1;
		}
	}else if (pinchGesture.state == UIGestureRecognizerStateEnded) {
		[openglController setZoom:101.1111 - zoomSlider.value];
		//[openglController drawFrame];
	}
	previousScale = pinchGesture.scale;
}

//--------------------------------------------------------------------------------------------------------

-(void)handleDoubleTap:(UIGestureRecognizer*)doubleTapGesture{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect zoomframe = self.zoomView.frame;
	CGRect f = colorPaletteView.frame;
	f.origin.x = -OPTIONS_VIEWS_WIDTH;
	colorPaletteView.frame = f;
	CALayer * layer = [algebraicSurfaceView layer];
	
	if(fullScreen){
		fullScreen = NO;
        //	[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
		layer.cornerRadius = 8;
		[algebraicSurfaceView setFrame:algebraicsurfaceViewFrame];
        //	[self.algebraicSurfaceView setFrame:CGRectMake(109, 7, 364, 2w58)];
		zoomframe.origin.y = 27;
        temporalimgView.frame = CGRectMake(0, 0, 400, 277);
        
	}else{
		fullScreen = YES;
		[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
		layer.cornerRadius = 0;
		[self.algebraicSurfaceView setFrame:FULL_SCREEN_SURFACE_FRAME];
		zoomframe.origin.y = algebraicSurfaceView.frame.origin.y + 55;
        temporalimgView.frame = CGRectMake(0, 0, 440, 320);
        
        
	}
	zoomframe.origin.x =   ZOOM_VIEW_X_POSITION;
    
	[self.zoomView setFrame:zoomframe];
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------
-(void)viewDidAppear:(BOOL)animated{
	
    //	[self performSelectorInBackground:@selector(doOpenGLMagic) withObject:nil];
	//  [self 	doOpenGLMagic];
	self.zoomSlider.value = 101.0 - [openglController zoom];
    
    if( self.firstTimeInApp){
        self.firstTimeInApp = NO;
    }else{
        [self doneButtonPressed];
    }

	[super viewDidAppear:animated];
	
}
//--------------------------------------------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
	//Generar superficie si es que viene de la galeria
	
	if( algebraicSurface ){
		[self.rotateimage setImage:self.algebraicSurface.surfaceImage];
	}
	[super viewWillAppear:animated];
}
//--------------------------------------------------------------------------------------------------------

-(void)viewWillDisappear:(BOOL)animated{
	[openglController stopAnimation];
    
	for( UIView* optionView in self.optionsViews ){
		[optionView setHidden:YES];
	}
	[super viewWillDisappear:animated];
}

#pragma mark buttons actions
//--------------------------------------------------------------------------------------------------------

- (IBAction)settingsSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    @synchronized(openglController)
    {
        if( slider.value >=0 && slider.value< 5){
            slider.value = 0;
            openglController.m_applicationEngine->ChangeSurface(0);
        }else if (slider.value >=5 && slider.value< 15){
            slider.value = 10;
            openglController.m_applicationEngine->ChangeSurface(1);
            
        }else if (slider.value >=15 && slider.value< 25){
            slider.value = 20;
            openglController.m_applicationEngine->ChangeSurface(2);
            
        }else if (slider.value >=25 && slider.value< 35){
            slider.value = 30;
            openglController.m_applicationEngine->ChangeSurface(3);
            
        }else if (slider.value >=35 && slider.value< 45){
            slider.value = 40;
            openglController.m_applicationEngine->ChangeSurface(4);
            
        }else if (slider.value >=45 && slider.value< 50){
            slider.value = 50;
            openglController.m_applicationEngine->ChangeSurface(5);
            
        }
        [openglController setZoom:openglController.zoom];
        //[openglController generateSurface:self.equationTextField.text];
        //[openglController drawFrame];
    }
}
//--------------------------------------------------------------------------------------------------------

- (IBAction)WireChanged:(id)sender {
    @synchronized(openglController)
    {
        
        programData::wireFrame = !programData::wireFrame;
        [openglController drawFrame];
    }
}

- (IBAction)CameraChanged:(id)sender {
    @synchronized(openglController)
    {
        
        programData::backgroundBlack = !programData::backgroundBlack;
        
        if(programData::backgroundBlack)
            baseView.backgroundColor = [UIColor blackColor];
        else
            baseView.backgroundColor = [UIColor whiteColor];
        

        [openglController drawFrame];
    }
}

- (IBAction)ToonShader:(id)sender {
    @synchronized(openglController)
    {
        
        
        programData::toonShader = !programData::toonShader;
        programData::setCellShade(programData::toonShader);
        
        [openglController drawFrame];
    }
}

- (IBAction)Texture:(id)sender {
    @synchronized(openglController)
    {
        
        
        programData::textureEnable = !programData::textureEnable;
        programData::setTexture(programData::textureEnable);
        
        [openglController drawFrame];
    }
}

//--------------------------------------------------------------------------------------------------------

-(IBAction)optionsButtonPressed:(id)sender{
	UIButton* button = (UIButton*)sender;
	switch (button.tag) {
		case 1:
			[self showOptionsViewWrapper:YES view:shareView];
            [self setSurfaceImg];
            [self postSurfaceToFacebook:self.temporalimgView.image];
			break;
		case 2:
            [self.view addSubview:colorpalette.view];
            
			[self showOptionsViewWrapper:YES view:colorpalette.view];
            [colorpalette setColor:_color1 andColor:self.color2];
			break;
        case 3:
            [self showOptionsViewWrapper:YES view:settingsView];
            break;
		default:
			break;
	}
}

-(IBAction)helpButtonPressed:(id)sender{
    [appcontroller goToHelp];
}

- (void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color{
    const float* colors = CGColorGetComponents( color.CGColor );
    [openglController setSurfaceColorRed:colors[0] Green:colors[1] Blue:colors[2]];
//	[self showOptionsViewWrapper:NO view:colorPicker.view];
    [openglController drawFrame];
    self.color1 = color;
    
}

-(void)removeColorPalette{
    [self showOptionsViewWrapper:NO view:colorPaletteView];
    [colorpalette.view removeFromSuperview];
    colorpalette.view.hidden = YES;
}


- (void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor2:(UIColor *)color{
    const float* colors = CGColorGetComponents( color.CGColor );
    [openglController setSurfaceColor2Red:colors[0] Green:colors[1] Blue:colors[2]];
	//[self showOptionsViewWrapper:NO view:colorPicker.view];
    [openglController drawFrame];
    self.color2 = color;

}
//--------------------------------------------------------------------------------------------------------
-(IBAction)hideOptions:(id)sender{
	UIButton* backButton = (UIButton*)sender;
	[self showOptionsViewWrapper:NO view:backButton.superview];
}

//--------------------------------------------------------------------------------------------------------
-(IBAction)keyboardBarButtonPressed:(id)sender{
	UIButton* button = (UIButton*)sender;
	self.equationTextField.text = [equationTextField.text stringByAppendingString:button.titleLabel.text];
}

-(IBAction)keyboardBarMinusButtonPressed:(id)sender{
	self.equationTextField.text = [equationTextField.text stringByAppendingString:@"\u2212"];
}

-(IBAction)keyboardBarHyppenMinusButtonPressed:(id)sender{
	self.equationTextField.text = [equationTextField.text stringByAppendingString:@"-"];
}

-(void)removeLoadingView{
    if( lv != NULL){
        [lv removeFromSuperview];
        lv = nil;
    }
}

-(void)doGenerateSurface:(NSString*)eqText{
    @synchronized(openglController)
    {

    NSString* eqstr = [eqText substringToIndex:eqText.length - 2];
    equationTextField.text = eqstr;
    NSLog(@"eq text  %@", equationTextField.text);
    }
    
}

-(void)doSurfaceGeneration{
    
    [openglController generateSurface:self.equationTextField.text];
    [self removeLoadingView];
}
//--------------------------------------------------------------------------------------------------------
-(IBAction)doneButtonPressed{
    [equationTextField resignFirstResponder];
    printf("Boton done apretado\n");
    [self scrollViewTo:nil movePixels:0 baseView:self.baseView];
    [self showExtKeyboard:NO];
    if( currentEquation != NULL || ![currentEquation isEqualToString:equationTextField.text]){
        lv = [LoadingView loadingView:@""];
        [self.view addSubview:lv];
        [self performSelector:@selector(doSurfaceGeneration) withObject:nil afterDelay:0.5];
        if(COUNTER == 0)
        {
            COUNTER++;
            [self performSelector:@selector(doSurfaceGeneration) withObject:nil afterDelay:0.5];
        }
    }
    currentEquation = [self.equationTextField.text copy];
    
    
    //  [openglController performSelectorInBackground:@selector(generateSurface:) withObject: self.equationTextField.text];
   	//aca habria que hacer todo el validamiento de la ecuacion
}

#pragma mark Keyboard methods
//--------------------------------------------------------------------------------------------------------
-(void)showExtKeyboard:(BOOL)yesOrNo {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect r=[self.keyboardExtensionBar frame];
	CGRect eqtxtfldFrame = self.equationTextfieldView.frame;
	if(yesOrNo){
		[self.algebraicSurfaceView setAlpha:0.0];
		self.saveButton.alpha = 0.0;
        eqtxtfldFrame.origin.y = EQUATION_TEXTFIELD_EDITING_HEIGHT;
        eqtxtfldFrame.size.width = 480;
     //   equationTextField.frame.size.width = 440;
		r.origin.y=  KEYBOARD_VIEW_SHOW_HEIGHT;
	}else{
		self.saveButton.alpha = 1.0;
		[self.algebraicSurfaceView setAlpha:1.0];
		eqtxtfldFrame.origin.y = EQUATION_TEXTFIELD_IDLE_HEIGHT;
		r.origin.y= KEYBOARD_VIEW_HIDE_HEIGHT;
        eqtxtfldFrame.size.width = 430;

	}
	[self.equationTextfieldView setFrame:eqtxtfldFrame];
	[self.keyboardExtensionBar setFrame:r];
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------

-(void)showOptionsView:(BOOL)yes view:(UIView*)showingView{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    
	if(yes){
        showingView.alpha =  1;
	}else{
        showingView.alpha =  0;
	}
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------

-(void)showOptionsViewWrapper:(BOOL)yes view:(UIView*)showingView{
	for( UIView* optionsView in self.optionsViews ){
		[self showOptionsView:NO view:optionsView];
	}
	if( showingView ){
		[showingView setHidden:!showingView.hidden];
		[self showOptionsView:yes view:showingView];
	}
}
//--------------------------------------------------------------------------------------------------------
- (void) keyboardWillHide: (NSNotification *) notification {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect thisViewFrame = [baseView frame];	
	thisViewFrame.origin.y = 0;

	[baseView setFrame:thisViewFrame];
	[UIView commitAnimations];
	[self showExtKeyboard:NO];
}
//--------------------------------------------------------------------------------------------------------
#pragma mark UITextfield delegate
//--------------------------------------------------------------------------------------------------------
-(IBAction)cancelKeyboard:(id)sender{
    [self scrollViewTo:nil movePixels:0 baseView:self.baseView];
	[self showExtKeyboard:NO];
    [equationTextField resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[self scrollViewTo:equationTextfieldView movePixels:VIEW_SCROLL baseView:self.baseView];
    [self showExtKeyboard:YES];
    
    //    [textField setEditing:YES];
    // [textField becomeFirstResponder];
  	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // [textField becomeFirstResponder];
    
    
}
//--------------------------------------------------------------------------------------------------------
#pragma mark dealloc

-(IBAction)saveImage{
	SaveAlgebraicSurfaceViewController* saveimg = [[SaveAlgebraicSurfaceViewController alloc]initWithAppController:self.appcontroller andImage: temporalimgView.image];
    saveimg.delegate = self;
	[self presentModalViewController:saveimg animated:YES];
	[saveimg release];
}
//--------------------------------------------------------------------------------------------------------

-(IBAction)flipToGalleries:(id)sender{
    
    [appcontroller goToGalleries];
}
//--------------------------------------------------------------------------------------------------------
-(IBAction)keyboardKeyTapped:(id)sender{
    UIButton* keyboardButton = (UIButton*)sender;
    switch (keyboardButton.tag) {
            
        case 30:{
            if(equationTextField.text.length > 0 ){                
                UITextRange *selRange = equationTextField.selectedTextRange;
                UITextPosition *selStartPos = selRange.start;
                NSInteger idx = [equationTextField offsetFromPosition:equationTextField.beginningOfDocument toPosition:selStartPos];
                if( idx > 0) {
                    NSString* str = [equationTextField.text substringToIndex:idx -1];
                    NSString* str2 = [equationTextField.text substringFromIndex:idx];                    
                    equationTextField.text = [NSString stringWithFormat:@"%@%@", str, str2];
                    [equationTextField selectTextForInputatRange:NSMakeRange(idx - 1, 0)];
                }
            }
            break;
        }
        default:
            equationTextField.text = [equationTextField.text stringByAppendingString:[keyboardButtons objectAtIndex:keyboardButton.tag]];
            break;
    }
    if(    [openglController ParseEqu:self.equationTextField.text])
        self.equationTextField.backgroundColor = [UIColor redColor];
    else
        self.equationTextField.backgroundColor = [UIColor whiteColor];
}
//--------------------------------------------------------------------------------------------------------

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
	[equationTextfieldView release];
	[algebraicSurfaceView release];
	[rotateimage release];
	[zoomSlider release];
	[zoomView release];
	[algebraicSurface release];
	[openglController release];
    [temporalimgView release];
    [colorButton release];
    [shareButton release];
    [saveButton release];
    [galleriesButton release];
    [settingsButton release];
    [helpButton release];
	[super dealloc];
}
//---------------------------------------------------------------------------------------------

-(void)setSurfaceImg{
    
    temporalimgView.image = [algebraicSurfaceView snapshot];
}
@end
