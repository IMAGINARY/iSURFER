//
//  ImageDescriptionViewController.m
//  iSurfer
//
//  Created by Cristian Prieto on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageDescriptionViewController.h"
#import "DataBaseController.h"

@implementation ImageDescriptionViewController
@synthesize gallery, surface, imageView, scrollView, formula, description;


-(id) initWithAppController:(AppController*)anappCtrl andSurface:(AlgebraicSurface*)aSurface {
	
	if (self = [super initWithNibName:@"ImageDescriptionViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
        [self setSurface:aSurface];
	}
	return self;
}

-(void)initialize{
    [self setImageView];
    [self setFormula];
    [self setDescription];
    //NSMutableArray* galleries = self.appcontroller.galleriesArray;
    //Gallery * firstGallery = [galleries objectAtIndex:0];
    //[self.appcontroller.dataBase populateGallery:firstGallery];
    //NSLog(@"%@", gallery.galleryName);
    //NSLog(@"%@", gallery.galleryDescription);
//    NSLog(@"%@", surface.equation);
//    NSLog(@"%@", surface.briefDescription);
}

-(void)setFormula{
    [formula setText:surface.equation];
}

-(void)setDescription
{
    [description setText:surface.completeDescription];
}

-(void)setImageView
{
    UIImage * image = [UIImage imageNamed:surface.realImageName];
    
    [imageView setImage: image];
}

-(void)viewDidLoad
{
    /*El content size es el tamaño de lo que está adentro del ScrollView.
    //El tamaño del ScrollView se setea desde el interface builder.
    //El tamaño del contentSize se setea en el código*/
    [self initialize];

    [description sizeToFit];
    [scrollView sizeToFit];
    
    float sizeOfContent = 0;
    int i;
    for (i = 0; i < [scrollView.subviews count]; i++) {
        UIView *view =[scrollView.subviews objectAtIndex:i];
        sizeOfContent += view.frame.size.height;
    }
    
    // Set content size for scroll view
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, sizeOfContent);

//    int descriptionLength = surface.completeDescription.length;
//    int height = descriptionLength/50*13;
//    height = height + imageView.frame.size.height;
//    [scrollView setContentSize:CGSizeMake(380, height)];
    [super viewDidLoad];
    
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
