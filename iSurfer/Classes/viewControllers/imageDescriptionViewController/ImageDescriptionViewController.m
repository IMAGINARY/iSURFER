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
@synthesize scrollView;
- (void)viewDidLoad {
    //---set the viewable frame of the scroll view---
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    //---set the content size of the scroll view---
    [scrollView setContentSize:CGSizeMake(320, 713)];    
    [super viewDidLoad];
}
- (void)dealloc {
    [scrollView release];
    [super dealloc];
}
@end
