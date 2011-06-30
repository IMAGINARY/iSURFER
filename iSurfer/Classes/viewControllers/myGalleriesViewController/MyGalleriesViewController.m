//
//  MyGalleriesViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyGalleriesViewController.h"


@implementation MyGalleriesViewController


-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"MyGalleriesViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}


@end
