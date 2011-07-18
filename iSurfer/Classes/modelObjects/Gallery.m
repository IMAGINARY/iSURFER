//
//  Gallery.m
//  iSurfer
//
//  Created by Damian Modernell on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Gallery.h"


@implementation Gallery

@synthesize galleryName, galleryDescription;

-(id) init{	
	if (self = [super init]) {
		self.galleryName = @"";
		self.galleryDescription = @"";
	}
	return self;
}

-(void)dealloc{
	[galleryName release];
	[galleryDescription release];
	[super dealloc];
}

@end
