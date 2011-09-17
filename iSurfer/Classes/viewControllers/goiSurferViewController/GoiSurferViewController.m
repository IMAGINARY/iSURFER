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

//--------------------------------------------------------------------------------------------------------
@interface GoiSurferViewController(PrivateMethods)
-(void)showOptionsViewWrapper:(BOOL)yes view:(UIView*)showingView;
@end
//--------------------------------------------------------------------------------------------------------
@implementation GoiSurferViewController
//--------------------------------------------------------------------------------------------------------
@synthesize equationTextField, keyboardExtensionBar, baseView, colorPaletteView, shareView, optionsViews, colorTestView, greenColorSlider, redColorSlider, blueColorSlider;
@synthesize algebraicSurfaceView, equationTextfieldView,rotateimage, saveButton, zoomSlider, zoomView, algebraicSurface;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl andAlgebraicSurface:(AlgebraicSurface*)surface{
	
	if (self = [super initWithNibName:@"GoiSurferViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
		if (surface) {
			self.algebraicSurface = surface;
		}
		optionsViews = [[NSMutableArray alloc]init];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
	//Color sliders conf
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
	CALayer * layer = [algebraicSurfaceView layer];
	layer.cornerRadius = 8;
	CALayer * layer2 = [shareView layer];
	layer2.cornerRadius = 8;
	CALayer * layer3 = [colorPaletteView layer];
	layer3.cornerRadius = 8;
	
	//Zoom slider
	UISlider* tmpzoomSlider = [[UISlider alloc]init];
	tmpzoomSlider.minimumValue = 0;
	tmpzoomSlider.maximumValue = 10;
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
	
	[xpos setHidden:YES];
	[ypos setHidden:YES];
	algebraicsurfaceViewFrame = algebraicSurfaceView.frame;
	
//	[self performSelectorInBackground:@selector(doOpenGLMagic) withObject:nil];
}
//--------------------------------------------------------------------------------------------------------

-(void)doOpenGLMagic{
	openglController = [[iSurferViewController alloc]init];
	openglController.view = algebraicSurfaceView;
	[openglController setupGLContxt];
//	[openglController performSelectorInBackground:@selector(startAnimation) withObject:nil];
	[openglController startAnimation];
}

//--------------------------------------------------------------------------------------------------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
	if([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] ||
	   [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] ){
		return YES;
	}
	return YES;
	
}
//--------------------------------------------------------------------------------------------------------
-(void)handleSingleLongPressTouch:(UILongPressGestureRecognizer*)singleLongPressGesture{
	NSLog(@"handleSingleLongPressTouch");
	switch (singleLongPressGesture.state) {
		case UIGestureRecognizerStateBegan:
			[xpos setHidden:NO];
			[ypos setHidden:NO];
			xpos.text = @"x: 0";
			ypos.text = @"x: 0";
			break;
		case UIGestureRecognizerStateChanged:
			break;
		case UIGestureRecognizerStateEnded:
			[xpos setHidden:YES];
			[ypos setHidden:YES];
			break;
		default:
			break;
	}
}
//--------------------------------------------------------------------------------------------------------

-(void)handlePanGesture:(UIPanGestureRecognizer*)gestureRecognizer{
	NSLog(@"handlePanGesture");

	CGPoint p;
	p = [gestureRecognizer translationInView:gestureRecognizer.view];

	switch (gestureRecognizer.state) {
		case UIGestureRecognizerStateBegan:
			break;
		case UIGestureRecognizerStateChanged:
			xpos.text = [NSString stringWithFormat:@"x: %.2f", p.x];
			ypos.text = [NSString stringWithFormat:@"y: %.2f", p.y];
			[openglController rotateX:p.x Y:p.y];
			break;
		case UIGestureRecognizerStateEnded:
			break;
		default:
			break;
	}
}
//--------------------------------------------------------------------------------------------------------
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
			self.zoomSlider.value -= 0.1;
		}else {
			self.zoomSlider.value += 0.1;
		}
	}
	previousScale = pinchGesture.scale;	
}

//--------------------------------------------------------------------------------------------------------

-(void)handleDoubleTap:(UIGestureRecognizer*)doubleTapGesture{	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect zoomframe = self.zoomView.frame;
	CALayer * layer = [algebraicSurfaceView layer];

	if(fullScreen){
		fullScreen = NO;
		[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
		layer.cornerRadius = 8;
		[algebraicSurfaceView setFrame:algebraicsurfaceViewFrame];
	//	[self.algebraicSurfaceView setFrame:CGRectMake(109, 7, 364, 258)];
		zoomframe.origin.x = 323;
		zoomframe.origin.y = 27;
	}else{
		fullScreen = YES;
		[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
		layer.cornerRadius = 0;
		[self.algebraicSurfaceView setFrame:CGRectMake(0, 0, 480, 320)];
		zoomframe.origin.x =  algebraicSurfaceView.frame.origin.x + 440;
		zoomframe.origin.y = algebraicSurfaceView.frame.origin.y + 55;
	}
	[self.zoomView setFrame:zoomframe];
	[UIView commitAnimations];
}
//--------------------------------------------------------------------------------------------------------
-(void)viewDidAppear:(BOOL)animated{
	
//	[self performSelectorInBackground:@selector(doOpenGLMagic) withObject:nil];
	[self 	doOpenGLMagic];
	[super viewDidAppear:animated];
	
}
//--------------------------------------------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
	//Generar superficie si es que viene de la galeria
	
	if( algebraicSurface ){
		[self.rotateimage setImage:self.algebraicSurface.thumbNailImage];
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
	CGRect r=[self.keyboardExtensionBar frame];
	CGRect eqtxtfldFrame = self.equationTextfieldView.frame;
	if(yesOrNo){
		[self.algebraicSurfaceView setAlpha:0.0];
		self.saveButton.alpha = 0.0;
		 eqtxtfldFrame.origin.y = EQUATION_TEXTFIELD_EDITING_HEIGHT;
		r.origin.y=  KEYBOARD_VIEW_SHOW_HEIGHT;
	}else{
		self.saveButton.alpha = 1.0;
		[self.algebraicSurfaceView setAlpha:1.0];
		eqtxtfldFrame.origin.y = EQUATION_TEXTFIELD_IDLE_HEIGHT;
		r.origin.y= KEYBOARD_VIEW_HIDE_HEIGHT;
	}
	[self.equationTextfieldView setFrame:eqtxtfldFrame];
	[self.keyboardExtensionBar setFrame:r];
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
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect thisViewFrame = [baseView frame];	
	thisViewFrame.origin.y = -20;
	[baseView setFrame:thisViewFrame];
	[UIView commitAnimations];
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
    [doneButton setImage:[UIImage imageNamed:@"done_up.png"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"done_down.png"] forState:UIControlStateHighlighted];
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
	[self scrollViewTo:equationTextfieldView movePixels:70 baseView:self.baseView];
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

-(IBAction)saveImage{
	SaveAlgebraicSurfaceViewController* saveimg = [[SaveAlgebraicSurfaceViewController alloc]initWithAppController:self.appcontroller];
	[self presentModalViewController:saveimg animated:YES];
	[saveimg release];
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
	[saveButton release];
	[zoomSlider release];
	[zoomView release];
	[algebraicSurface release];
	[openglController release];
	[super dealloc];
}
//---------------------------------------------------------------------------------------------
@end
