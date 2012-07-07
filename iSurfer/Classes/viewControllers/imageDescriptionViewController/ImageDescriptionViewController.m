//
//  ImageDescriptionViewController.m
//  iSurfer
//
//  Created by Cristian Prieto on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageDescriptionViewController.h"
#import "ImageDescriptionViewController.h"

@implementation ImageDescriptionViewController
@synthesize imageView, scrollView, formula, description;


-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"ImageDescriptionViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}

-(void)setFormula{
    [formula setText:@"formula"];
}

-(void)setDescription
{
    [description setText:@"description"];
}

-(void)setImageView
{
    UIImage * image = [UIImage imageNamed: @"Logo-twitter.png"];
    [imageView setImage: image];
}

-(void)viewDidLoad
{
    /*El content size es el tamaño de lo que está adentro del ScrollView.
    //El tamaño del ScrollView se setea desde el interface builder.
    //El tamaño del contentSize se setea en el código*/
    [scrollView setContentSize:CGSizeMake(380, 500)];
    [super viewDidLoad]; 
    [self setImageView];
    [self setFormula];
    [self setDescription];
    /*self.title = NSLocalizedString(@"TextViewTitle", @"");    
     
     [self setupTextView];*/
    
}

/*-(void)setupTextView

{
    
    self.textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
    
    self.textView.textColor = [UIColor blackColor];
    
    self.textView.font = [UIFont fontWithName:@"Arial" size:18];
    
    //self.textView.delegate = self;
    
    self.textView.backgroundColor = [UIColor whiteColor];
    
    self.textView.text = @"Hello this is about the text view, the difference in text view and the text field is that you can display large data or paragraph in text view but in text field you cant.";
    
    self.textView.returnKeyType = UIReturnKeyDefault;
    
    self.textView.keyboardType = UIKeyboardTypeDefault; 
    
    self.textView.scrollEnabled = YES;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview: self.textView];  // adding the text view to the view.
    
}*/

-(void)dealloc
{
    
    [imageView release];
    [scrollView release];
    [formula release];
    [description release];
    
    [super dealloc];
    
}

@end
