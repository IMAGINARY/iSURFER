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


    [super viewDidLoad];
    
}

-(void)dealloc
{
    
    [imageView release];
    [scrollView release];
    [formula release];
    [description release];
    
    [super dealloc];
    
}

@end
